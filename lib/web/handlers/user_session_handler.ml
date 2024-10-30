open Opium
open Lwt.Syntax
open Sapiens_backend

let new_ req =
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (User_login_view.make ?alert ())

let create req =
  let* user_result =
    let open Lwt_result.Syntax in
    let* email =
      Common.Request.decode_param
        ~decoder:Account.User.Email.of_string
        "email"
        req
    in
    let* password =
      Common.Request.decode_param
        ~decoder:Account.User.Password.of_string
        "password"
        req
    in
    Account.get_user_by_email_and_password ~email ~password
  in
  match user_result with
  | Ok user ->
    User_auth_handler.login_user user req
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Not_found ->
        "No user exist with this email and password."
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    let* () = Logs_lwt.err (fun m -> m "%s" message) in
    Response.of_html (User_login_view.make ~alert:(`error message) ())
    |> Lwt.return

let delete req = User_auth_handler.logout_user req
