open Lwt.Syntax
open Opium

module Env = struct
  let key : Sapiens_backend.Account.User.t Context.key =
    Context.Key.create ("user", Sapiens_backend.Account.User.sexp_of_t)
end

let ensure_user_token req =
  let user_token = Cookies.User_token.get req in
  match user_token with
  | Some user_token ->
    Some user_token, req
  | _ ->
    (match Cookies.Remember_me.get req with
    | Some user_token ->
      let req =
        req
        |> Request.add_cookie
             ~sign_with:Cookies.User_token.signer
             (Cookies.User_token.key, Sapiens_backend.Token.to_string user_token)
      in
      Some user_token, req
    | None ->
      None, req)

let fetch_current_user =
  let open Lwt.Syntax in
  let filter handler req =
    let* () =
      Logs_lwt.debug (fun m -> m "Calling %S middleware" "Fetch current user")
    in
    let user_token_opt, req = ensure_user_token req in
    match user_token_opt with
    | Some user_token ->
      let* user_opt =
        Sapiens_backend.Account.get_user_by_session_token user_token
        |> Lwt.map Result.to_option
      in
      (match user_opt with
      | Some user ->
        let env = Context.add Env.key user req.env in
        handler { req with env }
      | None ->
        handler req)
    | None ->
      handler req
  in
  Rock.Middleware.create ~name:"Fetch current user" ~filter

let require_authenticated_user =
  let filter handler req =
    let* () =
      Logs_lwt.debug (fun m ->
          m "Calling %S middleware" "Require authenticated user")
    in
    let user_opt = Context.find Env.key req.Request.env in
    match user_opt with
    | Some _ ->
      handler req
    | None ->
      let* () =
        Logs_lwt.debug (fun m ->
            m "User is not authenticated, redirecting to \"/users/login\"")
      in
      Response.redirect_to "/users/login"
      |> Flash.set_error "Your must be authenticated to access this page."
      |> Lwt.return
  in
  Rock.Middleware.create ~name:"Require authenticated user" ~filter

let redirect_if_user_is_authenticated =
  let filter handler req =
    let* () =
      Logs_lwt.debug (fun m ->
          m "Calling %S middleware" "Redirect if user is authenticated")
    in
    let user_opt = Context.find Env.key req.Request.env in
    match user_opt with
    | Some _ ->
      let* () =
        Logs_lwt.debug (fun m ->
            m "User is authenticated, redirecting to \"/\"")
      in
      Lwt.return @@ Response.redirect_to "/"
    | None ->
      handler req
  in
  Rock.Middleware.create ~name:"Redirect if user is authenticated" ~filter
