open Opium

let new_ req =
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (User_registration_view.make ?alert ())

let create req =
  let open Lwt.Syntax in
  let* user_registration_result =
    let open Lwt_result.Syntax in
    let* username =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Username.of_string
        "username"
        req
    in
    let* email =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Email.of_string
        "email"
        req
    in
    let* password =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "password"
        req
    in
    let* user =
      Sapiens_backend.Account.register_user ~username ~email ~password
    in
    let+ _ =
      Sapiens_backend.Account.deliver_user_confirmation_instructions
        user
        ~confirmation_url_fn:(fun token ->
          Config.base_url ^ "/users/confirm/" ^ token)
    in
    user
  in
  match user_registration_result with
  | Ok user ->
    User_auth_handler.login_user user req
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "A user with the same email or username already exist."
      | `Validation_error err ->
        err
      | `Already_confirmed | `Internal_error _ ->
        "An internal error occured."
    in
    let* () = Logs_lwt.err (fun m -> m "%s" message) in
    Response.of_html (User_registration_view.make ~alert:(`error message) ())
    |> Lwt.return
