module Dataset = Dataset_dataset
module Collabotor = Dataset_collaborator
module Datapoint = Dataset_datapoint
module Dataset_token = Dataset_token

module User_notifier =
(val match Config.notifier with
     | Email ->
       (module Dataset_user_notifier.Email : Dataset_user_notifier.S)
     | Console ->
       (module Dataset_user_notifier.Console : Dataset_user_notifier.S))

module Error = struct
  type t =
    [ `Invalid_token
    | Error.t
    ]
  [@@deriving show, eq]
end

let list_user_datasets ~as_ user =
  let open Lwt_result.Syntax in
  let+ user_datasets = Dataset.get_by_user user in
  List.filter (Dataset_permissions.can as_ `Index_dataset) user_datasets

let list_user_shared_datasets ~as_ user =
  let open Lwt_result.Syntax in
  let+ user_datasets = Dataset.get_shared_by_user user in
  List.filter (Dataset_permissions.can as_ `Index_dataset) user_datasets

let get_dataset_by_id ~as_ id =
  let open Lwt_result.Syntax in
  let* dataset = Dataset.get_by_id id in
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    Lwt.return_ok dataset
  | false ->
    Lwt.return_error `Permission_denied

let get_dataset_by_name_and_username ~as_ ~name ~username =
  let open Lwt_result.Syntax in
  let* dataset = Dataset.get_by_name_and_username ~name ~username in
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    Lwt.return_ok dataset
  | false ->
    Lwt.return_error `Permission_denied

let create_dataset ~as_ ~name ?description ?homepage ?citation ?is_public () =
  let open Lwt_result.Syntax in
  let open Dataset in
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT @int{id}
        FROM datasets
        WHERE name = %Name{name} AND user_id = %int{user_id}
        |sql}]
  in
  let* id_opt =
    Repo.query (fun c -> request c ~name ~user_id:as_.Account.User.id)
  in
  match id_opt with
  | Some _ ->
    Lwt.return (Error `Already_exists)
  | None ->
    Dataset.create
      ~user:as_
      ~name
      ?description
      ?homepage
      ?citation
      ?is_public
      ()

let update_dataset
    ~as_ ?name ?description ?homepage ?citation ?is_public dataset
  =
  let open Lwt_result.Syntax in
  let* () =
    match Dataset_permissions.can as_ `Update_dataset dataset with
    | true ->
      Lwt.return_ok ()
    | false ->
      Lwt.return_error `Permission_denied
  in
  match name with
  | Some name ->
    let open Lwt_result.Syntax in
    let open Dataset in
    let request =
      [%rapper
        get_opt
          {sql|
        SELECT @int{id}
        FROM datasets
        WHERE name = %Name{name} AND id <> %int{id}
        |sql}]
    in
    let* id_opt = Repo.query (fun c -> request c ~name ~id:dataset.id) in
    (match id_opt with
    | Some _ ->
      Lwt.return (Error `Already_exists)
    | None ->
      Dataset.update ~name ?description ?homepage ?citation ?is_public dataset)
  | None ->
    Dataset.update ?name ?description ?homepage ?citation ?is_public dataset

let delete_dataset ~as_ dataset =
  let open Lwt_result.Syntax in
  let* () =
    match Dataset_permissions.can as_ `Delete_dataset dataset with
    | true ->
      Lwt.return_ok ()
    | false ->
      Lwt.return_error `Permission_denied
  in
  Dataset.delete dataset

let search_datasets ~as_ query =
  let open Lwt_result.Syntax in
  let+ datasets = Dataset.search query in
  List.filter (Dataset_permissions.can as_ `Index_dataset) datasets

let get_dataset_datapoints ~as_ ?limit ?offset ?split dataset =
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    Datapoint.get_by_dataset ?limit ?offset ?split dataset
  | false ->
    Lwt.return_error `Permission_denied

let get_dataset_datapoint_count ~as_ dataset =
  let get_count_by_dataset dataset =
    let request =
      [%rapper
        get_one
          {sql|
          SELECT @int{count(DISTINCT dataset_datapoints.id)}
          FROM dataset_datapoints
          JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
          WHERE dataset_datapoints.dataset_id = %int{dataset_id}
          |sql}]
    in
    Repo.query (fun c -> request c ~dataset_id:dataset.Dataset_dataset.id)
  in
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    get_count_by_dataset dataset
  | false ->
    Lwt.return_error `Permission_denied

let create_dataset_datapoint ~as_ ~features ?split dataset =
  match Dataset_permissions.can as_ `Update_dataset dataset with
  | true ->
    Datapoint.create ~dataset ~features ?split ()
  | false ->
    Lwt.return_error `Permission_denied

let get_dataset_feature_definitions ~as_ dataset =
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    Datapoint.get_definitions_by_dataset dataset
  | false ->
    Lwt.return_error `Permission_denied

let create_dataset_feature_definition ~as_ ~name ~definition dataset =
  match Dataset_permissions.can as_ `Update_dataset dataset with
  | true ->
    let open Lwt_result.Syntax in
    let request =
      [%rapper
        get_opt
          {sql|
          SELECT @int{id}
          FROM dataset_feature_definitions
          WHERE feature_name = %string{name} AND dataset_id = %int{dataset_id}
          |sql}]
    in
    let* id_opt =
      Repo.query (fun c -> request c ~name ~dataset_id:dataset.Dataset.id)
    in
    (match id_opt with
    | Some _ ->
      Lwt.return (Error `Already_exists)
    | None ->
      Datapoint.create_definition ~dataset ~name definition)
  | false ->
    Lwt.return_error `Permission_denied

let update_dataset_feature_definition
    ~as_ ?name ?definition (t : Datapoint.definition)
  =
  let open Lwt_result.Syntax in
  let* dataset =
    get_dataset_by_id ~as_ t.dataset_id
    |> Lwt_result.map_err (function
           | `Not_found ->
             `Internal_error
               "The feature definition's dataset could not be found"
           | (`Internal_error _ | `Permission_denied) as err ->
             err)
  in
  match Dataset_permissions.can as_ `Update_dataset dataset with
  | true ->
    (match name with
    | Some name ->
      let request =
        [%rapper
          get_opt
            {sql|
        SELECT @int{id}
        FROM dataset_feature_definitions
        WHERE feature_name = %string{name} AND id <> %int{id}
        |sql}]
      in
      let* id_opt = Repo.query (fun c -> request c ~name ~id:t.id) in
      (match id_opt with
      | Some _ ->
        Lwt.return (Error `Already_exists)
      | None ->
        Datapoint.update_definition ~name ?spec:definition t)
    | None ->
      Datapoint.update_definition ?name ?spec:definition t)
  | false ->
    Lwt.return_error `Permission_denied

let delete_dataset_feature_definition ~as_ (t : Datapoint.definition) =
  let open Lwt_result.Syntax in
  let* dataset =
    get_dataset_by_id ~as_ t.dataset_id
    |> Lwt_result.map_err (function
           | `Not_found ->
             `Internal_error
               "The feature definition's dataset could not be found"
           | (`Internal_error _ | `Permission_denied) as err ->
             err)
  in
  match Dataset_permissions.can as_ `Update_dataset dataset with
  | true ->
    Datapoint.delete_definition t
  | false ->
    Lwt.return_error `Permission_denied

let deliver_collaboration_instructions ~as_ ~url_fn user dataset =
  let open Lwt_result.Syntax in
  match Dataset_permissions.can as_ `Add_collaborator dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    let* collaborators = Dataset_collaborator.get_all dataset in
    (match
       List.find_opt
         (fun el -> Int.equal el.Account.User.id user.Account.User.id)
         collaborators
     with
    | Some _ ->
      Lwt.return_error `Already_exists
    | None ->
      let* encoded_token, dataset_token =
        Dataset_token.build_invitation_token user dataset |> Lwt.return
      in
      let* _ = Dataset_token.insert dataset_token in
      User_notifier.deliver_invitation_instructions
        user
        ~inviter:as_
        ~dataset
        ~url:(url_fn (Token.to_string encoded_token)))

let accept_collaboration_invitation ~as_ token =
  let open Lwt_result.Syntax in
  let* user, dataset = Dataset_token.verify_invitation_token token in
  (* Validate that the user accepting the invitation is the invitee and that the
     email is the same. If the user changed his email, they need to be
     re-invited. *)
  if
    Account.User.Email.equal user.email as_.Account.User.email
    && Int.equal user.id as_.id
  then
    let* _ = Dataset_collaborator.add user dataset in
    let* _ = Dataset_token.delete_by_token token in
    get_dataset_by_id ~as_ dataset.id
    |> Lwt_result.map_err (function
           | `Not_found | `Permission_denied ->
             `Internal_error "The dataset could not be queries"
           | `Internal_error _ as err ->
             err)
  else
    Lwt.return_error `Invalid_token

let revoke_collaboration_invitation ~as_ user dataset =
  let open Lwt_result.Syntax in
  match Dataset_permissions.can as_ `Remove_collaborator dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    let* token =
      Dataset_token.get_invitation_by_user_id user.Account.User.id dataset
    in
    Dataset_token.delete_by_token token.token

let get_pending_collaboration_invitations ~as_ dataset =
  let open Lwt_result.Syntax in
  (* Reusing the List permission: if the user can add a collaborator, they can
     list the pending invitations. *)
  match Dataset_permissions.can as_ `Add_collaborator dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    let+ tokens = Dataset_token.get_all_invitations dataset in
    List.map (fun el -> el.Dataset_token.sent_to) tokens

let remove_collaborator ~as_ user dataset =
  match Dataset_permissions.can as_ `Remove_collaborator dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    Dataset_collaborator.remove user dataset

let deliver_transfer_instructions ~as_ ~url_fn user dataset =
  (* TODO: Check that there is no other transfer invitation pending. *)
  let open Lwt_result.Syntax in
  match Dataset_permissions.can as_ `Transfer_dataset dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    if Int.equal as_.id user.Account.User.id then
      Lwt.return_error `Already_exists
    else
      let* encoded_token, dataset_token =
        Dataset_token.build_transfer_token user dataset |> Lwt.return
      in
      let* _ = Dataset_token.insert dataset_token in
      User_notifier.deliver_transfer_instructions
        user
        ~inviter:as_
        ~dataset
        ~url:(url_fn (Token.to_string encoded_token))

let accept_transfer_invitation ~as_ token =
  let open Lwt_result.Syntax in
  let* user, dataset = Dataset_token.verify_transfer_token token in
  (* Validate that the user accepting the transfer is the invitee and that the
     email is the same. If the user changed his email, they need to be
     re-invited. *)
  if
    Account.User.Email.equal user.email as_.Account.User.email
    && Int.equal user.id as_.id
  then
    let* dataset = Dataset.update_owner user dataset in
    let+ _ = Dataset_token.delete_by_token token in
    dataset
  else
    Lwt.return_error `Invalid_token

let revoke_transfer_invitation ~as_ dataset =
  let open Lwt_result.Syntax in
  (* Reusing the Transfer_dataset permission: if the user can transfer the
     dataset, they can cancel it *)
  match Dataset_permissions.can as_ `Transfer_dataset dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    let* token = Dataset_token.get_transfer dataset in
    Dataset_token.delete_by_token token.token

let get_pending_transfer ~as_ dataset =
  let open Lwt_result.Syntax in
  match Dataset_permissions.can as_ `Transfer_dataset dataset with
  | false ->
    Lwt.return_error `Permission_denied
  | true ->
    let+ token = Dataset_token.get_transfer_opt dataset in
    (match token with
    | Some token ->
      Some token.Dataset_token.sent_to
    | None ->
      None)
