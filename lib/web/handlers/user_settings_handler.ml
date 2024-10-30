open Opium
open Lwt.Syntax

let edit req =
  let alert = Flash.get_message req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  Lwt.return @@ Response.of_html (User_settings_view.make ~user ?alert ())

let update_email req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
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
    Sapiens_backend.Account.deliver_update_email_instructions
      user
      ~email
      ~password
      ~update_email_url_fn:(fun token ->
        Config.base_url ^ "/users/confirm/" ^ token)
  in
  match result with
  | Ok _ ->
    Lwt.return
    @@ Response.of_html
         (User_settings_view.make
            ~user
            ~alert:
              (`success
                "A link to confirm your e-mail change has been sent to the new \
                 address.")
            ())
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "The email is already used by another user."
      | `Invalid_password ->
        "The user password is invalid."
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    let* () = Logs_lwt.err (fun m -> m "%s" message) in
    Lwt.return
    @@ Response.of_html
         (User_settings_view.make ~user ~alert:(`error message) ())

let confirm_email req =
  let token =
    Opium.Router.param req "token" |> Sapiens_backend.Token.of_string
  in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result = Sapiens_backend.Account.update_user_email user ~token in
  match result with
  | Ok _ ->
    Response.redirect_to "/users/settings"
    |> Flash.set_success "E-mail changed successfully."
    |> Lwt.return
  | Error `Not_found ->
    Response.redirect_to "/users/settings"
    |> Flash.set_error "Email change link is invalid or it has expired."
    |> Lwt.return
  | Error (`Internal_error _) ->
    Response.redirect_to "/users/settings"
    |> Flash.set_error "An internal error occured."
    |> Lwt.return

let update_password req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* current_password =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "current_password"
        req
    in
    let* new_password =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "new_password"
        req
    in
    Sapiens_backend.Account.update_user_password
      user
      ~current_password
      ~new_password
  in
  match result with
  | Ok user ->
    let redirect_to = "/users/settings" in
    let* res = User_auth_handler.login_user ~redirect_to user req in
    res |> Flash.set_success "Your password has been updated." |> Lwt.return
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Invalid_password ->
        "The current password is invalid"
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    let* () = Logs_lwt.err (fun m -> m "%s" message) in
    Lwt.return
    @@ Response.of_html
         (User_settings_view.make ~user ~alert:(`error message) ())

let delete_account req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* password =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Password.of_string
        "password"
        req
    in
    Sapiens_backend.Account.delete_user ~password user
  in
  match result with
  | Ok _ ->
    let* res = User_auth_handler.logout_user req in
    res |> Flash.set_success "Your account has been deleted." |> Lwt.return
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Validation_error _ | `Invalid_password ->
        "The current password is invalid"
      | `Internal_error _ ->
        "An internal error occured."
    in
    let* () = Logs_lwt.err (fun m -> m "%s" message) in
    Lwt.return
    @@ Response.of_html
         (User_settings_view.make ~user ~alert:(`error message) ())
