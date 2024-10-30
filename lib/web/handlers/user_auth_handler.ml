open Lwt.Syntax
open Opium

let maybe_write_remember_me_cookie ~token ~req res =
  let+ remember_me_opt = Request.urlencoded Cookies.Remember_me.key req in
  match remember_me_opt with
  | Some "true" ->
    Cookies.Remember_me.set token res
  | _ ->
    res

let login_user ?redirect_to user req =
  let* result = Sapiens_backend.Account.generate_session_token user in
  match result with
  | Ok token ->
    let redirect_path =
      Option.value
        redirect_to
        ~default:(Cookies.Return_to.get req |> Option.value ~default:"/")
    in
    Response.redirect_to ~status:`Found redirect_path
    |> Cookies.User_token.set token
    |> Cookies.Return_to.delete
    |> maybe_write_remember_me_cookie ~token ~req
  | Error (`Internal_error err) ->
    let* () = Logs_lwt.err (fun m -> m "%s" err) in
    Response.redirect_to "/users/login"
    |> Flash.set_error "An internal error occured."
    |> Lwt.return

(** This function renews the session ID and erases the whole session to avoid
    fixation attacks.

    If there is any data in the session you may want to preserve after
    login/logout, you must explicitly fetch the session data before clearing and
    then immediately set it after clearing *)
let renew_session () = ()

let logout_user req =
  let* result =
    let user_token =
      Cookies.User_token.get req
      |> Option.to_result ~none:(`Internal_error "The user is not logged in.")
    in
    match user_token with
    | Ok user_token ->
      Sapiens_backend.Account.delete_session_token user_token
    | Error e ->
      Lwt.return (Error e)
  in
  match result with
  | Ok () ->
    Response.redirect_to "/"
    |> Cookies.User_token.delete
    |> Cookies.Remember_me.delete
    |> Lwt.return
  | Error (`Internal_error _) ->
    Response.redirect_to "/"
    |> Flash.set_error "An internal error occured."
    |> Lwt.return
