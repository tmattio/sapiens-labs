type action =
  [ `Index_dataset
  | `Update_dataset
  | `Transfer_dataset
  | `Delete_dataset
  | `Add_collaborator
  | `Remove_collaborator
  | `Upload_dataset
  | `Create_annotation_task
  | `Cancel_annotation_task
  | `Complete_annotation_task
  ]

let is_user_collaborator user dataset =
  List.find_opt
    (fun u -> Int.equal user.Account.User.id u.Account.User.id)
    dataset.Dataset_dataset.collaborators
  |> Option.is_some

let can user action dataset =
  let user_id = user.Account.User.id in
  let dataset_owner_id = dataset.Dataset_dataset.user.id in
  if Int.equal user_id dataset_owner_id then
    true
  else if is_user_collaborator user dataset then
    match action with
    | `Index_dataset ->
      true
    | `Update_dataset ->
      false
    | `Transfer_dataset ->
      false
    | `Delete_dataset ->
      false
    | `Add_collaborator ->
      true
    | `Remove_collaborator ->
      true
    | `Upload_dataset ->
      true
    | `Create_annotation_task ->
      true
    | `Cancel_annotation_task ->
      true
    | `Complete_annotation_task ->
      true
  else if dataset.Dataset_dataset.is_public then
    match action with `Index_dataset -> true | _ -> false
  else
    false
