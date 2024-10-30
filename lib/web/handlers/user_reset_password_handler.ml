open Opium
open Lwt.Syntax

let new_ req =
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (User_reset_password_view.new_ ?alert ())

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
    Sapiens_backend.Account.deliver_user_reset_password_instructions
      user
      ~reset_password_url_fn:(fun token ->
        Config.base_url ^ "/users/reset_password/" ^ token)
  in
  (* Regardless of the outcome, show an impartial success/error message. *)
  Response.redirect_to "/"
  |> Flash.set_info
       "If your e-mail is in our system, you will receive instructions to \
        reset your password shortly."
  |> Lwt.return

let edit req =
  let token = Opium.Router.param req "token" in
  Lwt.return @@ Response.of_html (User_reset_password_view.edit ~token ())

let update req =
  let token_s = Opium.Router.param req "token" in
  let token = token_s |> Sapiens_backend.Token.of_string in
  let* result =
    let open Lwt_result.Syntax in
    let* password =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "password"
        req
    in
    let* password_confirmation =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "password_confirmation"
        req
    in
    let* user =
      Sapiens_backend.Account.get_user_by_reset_password_token token
    in
    Sapiens_backend.Account.reset_user_password
      user
      ~password
      ~password_confirmation
  in
  match result with
  | Ok _ ->
    Response.redirect_to "/users/login"
    |> Flash.set_success "Password reset successfully."
    |> Lwt.return
  | Error `Not_found ->
    Response.redirect_to "/"
    |> Flash.set_error "Reset password link is invalid or it has expired."
    |> Lwt.return
  | Error (`Msg err | `Validation_error err) ->
    Response.of_html
      (User_reset_password_view.edit ~token:token_s ~alert:(`error err) ())
    |> Lwt.return
  | Error (`Internal_error _) ->
    Response.of_html
      (User_reset_password_view.edit
         ~token:token_s
         ~alert:(`error "An internal error occured.")
         ())
    |> Lwt.return
