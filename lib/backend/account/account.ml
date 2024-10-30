open Account_user
module User_token = Account_user_token
module User = Account_user

module User_notifier =
(val match Config.notifier with
     | Email ->
       (module Account_user_notifier.Email : Account_user_notifier.S)
     | Console ->
       (module Account_user_notifier.Console : Account_user_notifier.S))

module Error = struct
  type t =
    [ `Already_confirmed
    | `Invalid_password
    | Error.t
    ]
  [@@deriving show, eq]
end

(* Database getters *)

let get_user_by_email email = User.get_by_email email

let get_user_by_username username = User.get_by_username username

let get_user_by_email_and_password ~email ~password =
  User.get_by_email_and_password ~email ~password

let get_user_by_id id = User.get_by_id id

let register_user ~username ~email ~password =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT @int{id}
        FROM users
        WHERE email = %Email{email} OR username = %Username{username}
        |sql}]
  in
  let* id_opt = Repo.query (fun c -> request c ~email ~username) in
  match id_opt with
  | Some _ ->
    Lwt.return (Error `Already_exists)
  | None ->
    User.create ~username ~email ~password

(* Settings *)

let update_user_email ~token user =
  let open Lwt_result.Syntax in
  let open User_token in
  let delete_token_req =
    [%rapper
      execute
        {sql|
        DELETE FROM users_tokens
        WHERE users_tokens.user_id = %int{user_id} AND users_tokens.context = %Context{context}
        |sql}]
  in
  let update_user_email_req =
    [%rapper
      get_one
        {sql|
        UPDATE users SET email = %Email{email}, confirmed_at = now()
        WHERE users.id = %int{user_id}
        RETURNING
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        |sql}
        record_out]
  in
  let* token =
    User_token.verify_change_email_token
      token
      ~context:(Change_email user.email)
  in
  let* token_sent_to =
    match token.sent_to with
    | Some v ->
      Lwt.return (Ok v)
    | None ->
      Lwt.return
        (Error (`Internal_error "The change email token is incomplete"))
  in
  Repo.transaction (fun c ->
      let open Lwt_result.Syntax in
      let* () = delete_token_req c ~user_id:user.id ~context:token.context in
      update_user_email_req c ~email:token_sent_to ~user_id:user.id)

let deliver_update_email_instructions ~email ~password ~update_email_url_fn user
  =
  if User.Email.equal user.User.email email then
    Lwt.return
      (Error (`Validation_error "The email is the same as the current one."))
  else if not (User.is_password_valid user ~password) then
    Lwt.return (Error `Invalid_password)
  else
    let open Lwt.Syntax in
    let* user_with_email = get_user_by_email email in
    match user_with_email with
    | Ok _ ->
      Lwt.return (Error `Already_exists)
    | Error `Not_found ->
      let updated_user = { user with email } in
      let open Lwt_result.Syntax in
      let* encoded_token, user_token =
        User_token.build_email_token
          updated_user
          ~context:(Change_email user.email)
        |> Lwt.return
      in
      let* _ = User_token.insert user_token in
      User_notifier.deliver_confirmation_instructions
        updated_user
        ~url:(update_email_url_fn (Token.to_string encoded_token))
    | Error (`Internal_error _) as err ->
      Lwt.return err

let update_user_password ~current_password ~new_password user =
  if Password.verify ~hash:user.hashed_password ~plain:current_password then
    let delete_tokens_req =
      [%rapper
        execute
          {sql|
          DELETE FROM users_tokens
          WHERE users_tokens.user_id = %int{user_id}
          |sql}]
    in
    let update_user_password_req =
      [%rapper
        get_one
          {sql|
          UPDATE users SET hashed_password = %Password{hashed_password}
          WHERE users.id = %int{user_id}
          RETURNING
            @int{id},
            @Username{username},
            @Password{hashed_password},
            @Email{email},
            @ptime?{confirmed_at},
            @ptime{created_at},
            @ptime{updated_at}
          |sql}
          record_out]
    in
    let hashed_password = Password.hash new_password in
    Repo.transaction (fun c ->
        let open Lwt_result.Syntax in
        let* () = delete_tokens_req c ~user_id:user.id in
        update_user_password_req c ~user_id:user.id ~hashed_password)
  else
    Error `Invalid_password |> Lwt.return

(* Session *)

let generate_session_token user =
  let open Lwt_result.Syntax in
  let* token, user_token = User_token.build_session_token user |> Lwt.return in
  let+ _ = User_token.insert user_token in
  token

let get_user_by_session_token token = User_token.verify_session_token token

let delete_session_token token =
  User_token.delete_by_token ~context:Session token

(* Confirmation *)

let deliver_user_confirmation_instructions ~confirmation_url_fn user =
  let open Lwt_result.Syntax in
  match user.User.confirmed_at with
  | Some _ ->
    Lwt_result.lift (Error `Already_confirmed)
  | None ->
    let* encoded_token, user_token =
      User_token.build_email_token user ~context:Confirm |> Lwt.return
    in
    let* _ = User_token.insert user_token in
    User_notifier.deliver_confirmation_instructions
      user
      ~url:(confirmation_url_fn (Token.to_string encoded_token))

let confirm_user token =
  let open Lwt_result.Syntax in
  let open User_token in
  let* user = User_token.verify_email_token token ~context:Confirm in
  let delete_token_req =
    [%rapper
      execute
        {sql|
        DELETE FROM users_tokens
        WHERE users_tokens.user_id = %int{user_id} AND users_tokens.context = %Context{context}
        |sql}]
  in
  let update_user_confirmation_req =
    [%rapper
      get_one
        {sql|
        UPDATE users SET confirmed_at = now()
        WHERE users.id = %int{user_id}
        RETURNING
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        |sql}
        record_out]
  in
  Repo.transaction (fun c ->
      let open Lwt_result.Syntax in
      let* () =
        delete_token_req c ~user_id:user.id ~context:User_token.Context.Confirm
      in
      update_user_confirmation_req c ~user_id:user.id)

(* Reset password *)

let deliver_user_reset_password_instructions ~reset_password_url_fn user =
  let open Lwt_result.Syntax in
  let* encoded_token, user_token =
    User_token.build_email_token user ~context:Reset_password |> Lwt.return
  in
  let* _ = User_token.insert user_token in
  User_notifier.deliver_reset_password_instructions
    user
    ~url:(reset_password_url_fn (Token.to_string encoded_token))

let get_user_by_reset_password_token token =
  User_token.verify_email_token token ~context:Reset_password

let reset_user_password ~password ~password_confirmation user =
  if User.Password.equal password password_confirmation then
    let delete_token_req =
      [%rapper
        execute
          {sql|
          DELETE FROM users_tokens
          WHERE users_tokens.user_id = %int{user_id}
          |sql}]
    in
    let update_user_password_req =
      [%rapper
        get_one
          {sql|
          UPDATE users SET hashed_password = %Password{hashed_password}
          WHERE users.id = %int{user_id}
          RETURNING
            @int{id},
            @Username{username},
            @Password{hashed_password},
            @Email{email},
            @ptime?{confirmed_at},
            @ptime{created_at},
            @ptime{updated_at}
          |sql}
          record_out]
    in
    let hashed_password = Password.hash password in
    Repo.transaction (fun c ->
        let open Lwt_result.Syntax in
        let* () = delete_token_req c ~user_id:user.id in
        update_user_password_req c ~hashed_password ~user_id:user.id)
  else
    Lwt.return (Error (`Validation_error "The passwords don't match."))

let delete_user ~password user =
  if not (User.is_password_valid user ~password) then
    Lwt.return (Error `Invalid_password)
  else
    let open Lwt_result.Syntax in
    let* _ = User.delete user in
    let+ _ = User_notifier.deliver_deleted_account_email user in
    ()
