open Account_user

module Config = struct
  (* It is very important to keep the reset password token expiry short, since
     someone with access to the e-mail may take over the account. *)
  let reset_password_validity_in_days = 1

  let confirm_validity_in_days = 7

  let change_email_validity_in_days = 7

  let session_validity_in_days = 60
end

module Context = struct
  type t =
    | Confirm
    | Reset_password
    | Session
    | Change_email of Email.t
  [@@deriving show, eq]

  let to_validity = function
    | Confirm ->
      Config.confirm_validity_in_days
    | Reset_password ->
      Config.reset_password_validity_in_days
    | Session ->
      Config.session_validity_in_days
    | Change_email _ ->
      Config.change_email_validity_in_days

  let t =
    let encode = function
      | Confirm ->
        Ok "confirm"
      | Reset_password ->
        Ok "reset_password"
      | Session ->
        Ok "session"
      | Change_email email ->
        Ok ("change:" ^ Email.to_string email)
    in
    let decode = function
      | "confirm" ->
        Ok Confirm
      | "reset_password" ->
        Ok Reset_password
      | "session" ->
        Ok Session
      | s ->
        let string_len = String.length s in
        if
          string_len > 7
          && String.equal "change:" (StringLabels.sub s ~pos:0 ~len:7)
        then
          let open Std.Result.Syntax in
          let* email =
            Email.of_string (StringLabels.sub s ~pos:7 ~len:(string_len - 7))
            |> Result.map_error (fun _ -> "invalid change email context")
          in
          Ok (Change_email email)
        else
          Error "invalid context"
    in
    Caqti_type.(custom ~encode ~decode string)
end

type t =
  { token : Token.t
  ; user_id : int
  ; context : Context.t
  ; sent_to : Email.t option
  }
[@@deriving show, eq]

let build_session_token user =
  let open Std.Result.Syntax in
  let token = Token.generate () in
  let+ base64 = Token.encode_base64 token in
  base64, { token; context = Session; sent_to = None; user_id = user.id }

let build_email_token ~context user =
  let token = Token.generate () in
  let hashed_token = Token.hash token in
  let base64 = Token.encode_base64 token in
  match base64 with
  | Error err ->
    Error err
  | Ok base64 ->
    Ok
      ( base64
      , { token = hashed_token
        ; context
        ; sent_to = Some user.email
        ; user_id = user.id
        } )

let verify_session_token token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  let validity = Context.to_validity Session |> string_of_int in
  let request =
    [%rapper
      get_opt
        {sql|
          SELECT 
            users.@int{id},
            users.@Username{username},
            users.@Password{hashed_password},
            users.@Email{email},
            users.@ptime?{confirmed_at},
            users.@ptime{created_at},
            users.@ptime{updated_at}
          FROM users
          INNER JOIN users_tokens ON users.id = users_tokens.user_id
          WHERE users_tokens.token = %Token{token} AND
            users_tokens.context = %Context{context} AND
            users_tokens.created_at > now() - (%string{validity} || ' DAY')::INTERVAL
          |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~token ~context:Session ~validity)

let verify_email_token ~context token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  let validity = Context.to_validity context |> string_of_int in
  let request =
    [%rapper
      get_opt
        {sql|
          SELECT 
            users.@int{id},
            users.@Username{username},
            users.@Password{hashed_password},
            users.@Email{email},
            users.@ptime?{confirmed_at},
            users.@ptime{created_at},
            users.@ptime{updated_at}
          FROM users
          INNER JOIN users_tokens ON users.id = users_tokens.user_id
          WHERE users_tokens.token = %Token{token} AND
            users_tokens.sent_to = users.email AND
            users_tokens.context = %Context{context} AND
            users_tokens.created_at > now() - (%string{validity} || ' DAY')::INTERVAL
          |sql}
        record_out]
  in
  let hashed_token = Token.hash token in
  Repo.query_opt (fun c -> request c ~token:hashed_token ~context ~validity)

let verify_change_email_token ~context token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  let validity = Context.to_validity context |> string_of_int in
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT 
          users_tokens.@Token{token},
          users_tokens.@int{user_id},
          users_tokens.@Context{context},
          users_tokens.@Email?{sent_to}
        FROM users_tokens
        WHERE users_tokens.token = %Token{token} AND
          users_tokens.context = %Context{context} AND
          users_tokens.created_at > now() - (%string{validity} || ' DAY')::INTERVAL
        |sql}
        record_out]
  in
  let hashed_token = Token.hash token in
  Repo.query_opt (fun c -> request c ~token:hashed_token ~context ~validity)

let insert t =
  let request =
    [%rapper
      get_one
        {sql|
        INSERT INTO users_tokens (user_id, token, context, sent_to)
        VALUES (%int{user_id}, %Token{token}, %Context{context}, %Email?{sent_to})
        RETURNING 
          users_tokens.@Token{token},
          users_tokens.@int{user_id},
          users_tokens.@Context{context},
          users_tokens.@Email?{sent_to}
        |sql}
        record_in
        record_out]
  in
  Repo.query (fun c -> request t c)

let get_by_token ?context token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  match context with
  | Some context ->
    let request =
      [%rapper
        get_opt
          {sql|
          SELECT 
            users_tokens.@Token{token},
            users_tokens.@int{user_id},
            users_tokens.@Context{context},
            users_tokens.@Email?{sent_to}
          FROM users_tokens
          WHERE users_tokens.token = %Token{token} AND users_tokens.context = %Context{context}
          |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~token ~context)
  | None ->
    let request =
      [%rapper
        get_opt
          {sql|
          SELECT 
            users_tokens.@Token{token},
            users_tokens.@int{user_id},
            users_tokens.@Context{context},
            users_tokens.@Email?{sent_to}
          FROM users_tokens
          WHERE users_tokens.token = %Token{token}
          |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~token)

let get_by_user_id user_id =
  let request =
    [%rapper
      get_opt
        {sql|
          SELECT 
            users_tokens.@Token{token},
            users_tokens.@int{user_id},
            users_tokens.@Context{context},
            users_tokens.@Email?{sent_to}
          FROM users_tokens
          WHERE users_tokens.user_id = %int{user_id}
          |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~user_id)

let delete_by_token ?context token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  match context with
  | Some context ->
    let request =
      [%rapper
        execute
          {sql|
          DELETE FROM users_tokens
          WHERE users_tokens.token = %Token{token} AND users_tokens.context = %Context{context}
          |sql}]
    in
    Repo.query (fun c -> request c ~token ~context)
  | None ->
    let request =
      [%rapper
        execute
          {sql|
          DELETE FROM users_tokens
          WHERE users_tokens.token = %Token{token}
          |sql}]
    in
    Repo.query (fun c -> request c ~token)
