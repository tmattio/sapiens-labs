let get_all dataset =
  let request =
    let open Account.User in
    [%rapper
      get_many
        {sql|
          SELECT
            @int{users.id},
            @Username{users.username}, 
            @Password{users.hashed_password}, 
            @Email{users.email}, 
            @ptime?{users.confirmed_at}, 
            @ptime{users.created_at}, 
            @ptime{users.updated_at}
          FROM users
          INNER JOIN dataset_collaborators ON dataset_collaborators.user_id = users.id
          WHERE dataset_collaborators.dataset_id = %int{dataset_id}
          |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~dataset_id:dataset.Dataset_dataset.id)

let add user dataset =
  let user_id = user.Account.User.id in
  let dataset_id = dataset.Dataset_dataset.id in
  let request =
    [%rapper
      execute
        {sql| 
        INSERT INTO dataset_collaborators (dataset_id, user_id)
        VALUES (%int{dataset_id}, %int{user_id})
        |sql}]
  in
  Repo.query (fun c -> request c ~dataset_id ~user_id)

let remove user dataset =
  let user_id = user.Account.User.id in
  let dataset_id = dataset.Dataset_dataset.id in
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM dataset_collaborators
        WHERE dataset_id = %int{dataset_id} AND user_id = %int{user_id}
        |sql}]
  in
  Repo.query (fun c -> request c ~dataset_id ~user_id)
