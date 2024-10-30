open Opium
open Lwt.Syntax

let new_ req =
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (User_confirmation_view.new_ ?alert ())

let create req =
  let* _ =
    let open Lwt_result.Syntax in
    let* email =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Email.of_string
        "email"
        req
    in
    let* user = Sapiens_backend.Account.get_user_by_email email in
    Sapiens_backend.Account.deliver_user_confirmation_instructions
      user
      ~confirmation_url_fn:(fun token ->
        Config.base_url ^ "/users/confirm/" ^ token)
  in
  (* Regardless of the outcome, show an impartial success/error message. *)
  Response.redirect_to "/"
  |> Flash.set_info
       "If your e-mail is in our system and it has not been confirmed yet, you \
        will receive an e-mail with instructions shortly."
  |> Lwt.return

let confirm req =
  let token =
    Opium.Router.param req "token" |> Sapiens_backend.Token.of_string
  in
  let* result = Sapiens_backend.Account.confirm_user token in
  match result with
  | Ok _ ->
    Response.redirect_to "/"
    |> Flash.set_success "Account confirmed successfully."
    |> Lwt.return
  | Error `Not_found ->
    Response.redirect_to "/"
    |> Flash.set_error "Confirmation link is invalid or it has expired."
    |> Lwt.return
  | Error (`Internal_error _) ->
    Response.redirect_to "/"
    |> Flash.set_error "An internal error occured."
    |> Lwt.return
