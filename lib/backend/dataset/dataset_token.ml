module Config = struct
  let collaboration_invitation_validity_in_days = 7

  let transfer_invitation_validity_in_days = 7
end

module Context = struct
  type t =
    | Invite_collaborator
    | Transfer
  [@@deriving show, eq]

  let to_validity = function
    | Invite_collaborator ->
      Config.collaboration_invitation_validity_in_days
    | Transfer ->
      Config.transfer_invitation_validity_in_days

  let t =
    let encode = function
      | Invite_collaborator ->
        Ok "collaboration_invitation"
      | Transfer ->
        Ok "transfer"
    in
    let decode = function
      | "collaboration_invitation" ->
        Ok Invite_collaborator
      | "transfer" ->
        Ok Transfer
      | _ ->
        Error "invalid context"
    in
    Caqti_type.(custom ~encode ~decode string)
end

type t =
  { token : Token.t
  ; user_id : int
  ; dataset_id : int
  ; context : Context.t
  ; sent_to : Account.User.Email.t
  }
[@@deriving show, eq]

let build_token (user : Account_user.t) (dataset : Dataset_dataset.t) ~context =
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
        ; sent_to = user.email
        ; user_id = user.id
        ; dataset_id = dataset.id
        } )

let build_invitation_token user dataset =
  build_token user dataset ~context:Invite_collaborator

let build_transfer_token user dataset =
  build_token user dataset ~context:Transfer

let user_of_rapper
    ~id ~username ~hashed_password ~email ~confirmed_at ~created_at ~updated_at
  =
  Account_user.make
    ~id
    ~username
    ~hashed_password
    ~email
    ?confirmed_at
    ~created_at
    ~updated_at
    ()

let verify_token token ~context =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  let validity = Context.to_validity Invite_collaborator |> string_of_int in
  let request =
    let open Account.User in
    [%rapper
      get_opt
        {sql|
          SELECT 
            @int{users.id},
            @Username{users.username},
            @Password{users.hashed_password},
            @Email{users.email},
            @ptime?{users.confirmed_at},
            @ptime{users.created_at},
            @ptime{users.updated_at},
            @int{datasets.id}
          FROM users
          INNER JOIN datasets_tokens ON users.id = datasets_tokens.user_id
          INNER JOIN datasets ON datasets.id = datasets_tokens.dataset_id
          WHERE datasets_tokens.token = %Token{token} AND
            datasets_tokens.sent_to = users.email AND
            datasets_tokens.context = %Context{context} AND
            datasets_tokens.created_at > now() - (%string{validity} || ' DAY')::INTERVAL
          |sql}
        function_out]
  in
  let hashed_token = Token.hash token in
  let* user, dataset_id =
    Repo.query_opt (fun c ->
        request
          (user_of_rapper, fun ~id -> id)
          c
          ~token:hashed_token
          ~context
          ~validity)
  in
  let+ dataset = Dataset_dataset.get_by_id dataset_id in
  user, dataset

let verify_invitation_token token =
  verify_token token ~context:Invite_collaborator

let verify_transfer_token token = verify_token token ~context:Transfer

let insert t =
  let request =
    let open Account.User in
    [%rapper
      get_one
        {sql|
        INSERT INTO datasets_tokens (user_id, dataset_id, token, context, sent_to)
        VALUES (%int{user_id}, %int{dataset_id}, %Token{token}, %Context{context}, %Email{sent_to})
        RETURNING 
          datasets_tokens.@Token{token},
          datasets_tokens.@int{user_id},
          datasets_tokens.@int{dataset_id},
          datasets_tokens.@Context{context},
          datasets_tokens.@Email{sent_to}
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
      let open Account.User in
      [%rapper
        get_opt
          {sql|
          SELECT 
            datasets_tokens.@Token{token},
            datasets_tokens.@int{user_id},
            datasets_tokens.@int{dataset_id},
            datasets_tokens.@Context{context},
            datasets_tokens.@Email{sent_to}
          FROM datasets_tokens
          WHERE datasets_tokens.token = %Token{token} AND datasets_tokens.context = %Context{context}
          |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~token ~context)
  | None ->
    let request =
      let open Account.User in
      [%rapper
        get_opt
          {sql|
          SELECT 
            datasets_tokens.@Token{token},
            datasets_tokens.@int{user_id},
            datasets_tokens.@int{dataset_id},
            datasets_tokens.@Context{context},
            datasets_tokens.@Email{sent_to}
          FROM datasets_tokens
          WHERE datasets_tokens.token = %Token{token}
          |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~token)

let delete_by_token ?context token =
  let open Lwt_result.Syntax in
  let* token = Token.decode_base64 token |> Lwt.return in
  match context with
  | Some context ->
    let request =
      [%rapper
        execute
          {sql|
          DELETE FROM datasets_tokens
          WHERE datasets_tokens.token = %Token{token} AND datasets_tokens.context = %Context{context}
          |sql}]
    in
    Repo.query (fun c -> request c ~token ~context)
  | None ->
    let request =
      [%rapper
        execute
          {sql|
          DELETE FROM datasets_tokens
          WHERE datasets_tokens.token = %Token{token}
          |sql}]
    in
    Repo.query (fun c -> request c ~token)

let get_all ?context dataset =
  let dataset_id = dataset.Dataset_dataset.id in
  let open Account.User in
  match context with
  | Some context ->
    let request =
      [%rapper
        get_many
          {sql|
          SELECT 
            datasets_tokens.@Token{token},
            datasets_tokens.@int{user_id},
            datasets_tokens.@int{dataset_id},
            datasets_tokens.@Context{context},
            datasets_tokens.@Email{sent_to}
          FROM datasets_tokens
          WHERE dataset_id = %int{dataset_id} AND context = %Context{context}
          |sql}
          record_out]
    in
    Repo.query (fun c -> request c ~dataset_id ~context)
  | None ->
    let request =
      [%rapper
        get_many
          {sql|
              SELECT 
                datasets_tokens.@Token{token},
                datasets_tokens.@int{user_id},
                datasets_tokens.@int{dataset_id},
                datasets_tokens.@Context{context},
                datasets_tokens.@Email{sent_to}
              FROM datasets_tokens
              WHERE dataset_id = %int{dataset_id}
              |sql}
          record_out]
    in
    Repo.query (fun c -> request c ~dataset_id)

let get_all_invitations dataset = get_all ~context:Invite_collaborator dataset

let get_transfer' ~f dataset =
  let dataset_id = dataset.Dataset_dataset.id in
  let request =
    let open Account.User in
    [%rapper
      get_opt
        {sql|
      SELECT 
        datasets_tokens.@Token{token},
        datasets_tokens.@int{user_id},
        datasets_tokens.@int{dataset_id},
        datasets_tokens.@Context{context},
        datasets_tokens.@Email{sent_to}
      FROM datasets_tokens
      WHERE dataset_id = %int{dataset_id} AND context = %Context{context}
      |sql}
        record_out]
  in
  f (fun c -> request c ~dataset_id ~context:Transfer)

let get_transfer dataset = get_transfer' ~f:Repo.query_opt dataset

let get_transfer_opt dataset = get_transfer' ~f:Repo.query dataset

let get_by_user_id ?context user_id dataset =
  let dataset_id = dataset.Dataset_dataset.id in
  let open Account.User in
  match context with
  | Some context ->
    let request =
      [%rapper
        get_opt
          {sql|
          SELECT 
            datasets_tokens.@Token{token},
            datasets_tokens.@int{user_id},
            datasets_tokens.@int{dataset_id},
            datasets_tokens.@Context{context},
            datasets_tokens.@Email{sent_to}
          FROM datasets_tokens
          WHERE dataset_id = %int{dataset_id} AND context = %Context{context} AND user_id = %int{user_id}
          |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~dataset_id ~user_id ~context)
  | None ->
    let request =
      [%rapper
        get_opt
          {sql|
              SELECT 
                datasets_tokens.@Token{token},
                datasets_tokens.@int{user_id},
                datasets_tokens.@int{dataset_id},
                datasets_tokens.@Context{context},
                datasets_tokens.@Email{sent_to}
              FROM datasets_tokens
              WHERE dataset_id = %int{dataset_id} AND user_id = %int{user_id}
              |sql}
          record_out]
    in
    Repo.query_opt (fun c -> request c ~dataset_id ~user_id)

let get_invitation_by_user_id user_id dataset =
  get_by_user_id ~context:Invite_collaborator user_id dataset

let get_transfer_by_user_id user_id dataset =
  get_by_user_id ~context:Transfer user_id dataset
