module type Dataset = Dataset_intf.S

let datasets = []

let lwt_result_fold_left ~f l =
  let open Lwt_result.Syntax in
  let+ l =
    ListLabels.fold_left l ~init:(Lwt_result.return []) ~f:(fun acc el ->
        let* acc = acc in
        let+ result = f el in
        result :: acc)
  in
  List.rev l

exception Internal_error

let get_user_or_create ~username ~email =
  let open Lwt_result.Syntax in
  let* user_email =
    Sapiens_backend.Account.User.Email.of_string email |> Lwt_result.lift
  in
  let open Lwt.Syntax in
  let* fetched_user = Sapiens_backend.Account.get_user_by_email user_email in
  match fetched_user with
  | Ok d ->
    Lwt.return (Ok d)
  | Error (`Internal_error s) ->
    Logs.err (fun m -> m "Internal error: %s" s);
    raise Internal_error
  | _ ->
    let open Lwt_result.Syntax in
    let username_str = username in
    let email_str = email in
    let* username =
      Sapiens_backend.Account.User.Username.of_string username
      |> Lwt_result.lift
    in
    let* password =
      Sapiens_backend.Account.User.Password.of_string "demodemo1234"
      |> Lwt_result.lift
    in
    Logs.info (fun m -> m "  - create user %s <%s>" username_str email_str);
    Sapiens_backend.Account.register_user ~username ~email:user_email ~password

let force_create_dataset ~user ~name =
  let open Lwt.Syntax in
  let username = user.Sapiens_backend.Account.User.username in
  let name =
    Sapiens_backend.Dataset.Dataset.Name.of_string name |> Result.get_ok
  in
  let* fetched_dataset =
    Sapiens_backend.Dataset.get_dataset_by_name_and_username
      ~as_:user
      ~name
      ~username
  in
  let open Lwt_result.Syntax in
  let* () =
    match fetched_dataset with
    | Ok d ->
      Sapiens_backend.Dataset.delete_dataset ~as_:user d
    | _ ->
      Lwt.return (Ok ())
  in
  Sapiens_backend.Dataset.create_dataset ~as_:user ~name ()

let add_collaborators dataset collaborators =
  let open Lwt_result.Syntax in
  let* _ =
    lwt_result_fold_left
      ~f:(fun (username, email) ->
        Logs.info (fun m -> m "  - get_user_or_create ");
        let* user = get_user_or_create ~username ~email in
        Logs.info (fun m -> m "  - Sapiens_backend.Dataset.Collabotor.add ");
        Sapiens_backend.Dataset.Collabotor.add user dataset)
      collaborators
  in
  Lwt.return_ok ()

let add_tasks ?guidelines dataset definitions tasks =
  let open Lwt_result.Syntax in
  Logs.info (fun m -> m "  -  get_user_by_email");
  let* creator =
    Sapiens_backend.Account.get_user_by_email
      (Sapiens_backend.Account.User.Email.of_string "thibaut.mattio@gmail.com"
      |> Result.get_ok)
  in
  let* _ =
    lwt_result_fold_left
      ~f:(fun (name, assignee, inputs, outputs) ->
        Logs.info (fun m -> m "  -  get_user_by_email <%s>" assignee);
        let* user =
          Sapiens_backend.Account.get_user_by_email
            (Sapiens_backend.Account.User.Email.of_string assignee
            |> Result.get_ok)
        in
        let input_feature_ids =
          List.map
            (fun input ->
              let definition =
                List.find
                  (fun (el :
                         'a
                         Sapiens_backend.Dataset.Datapoint.persisted_definition) ->
                    String.equal el.feature_name input)
                  definitions
              in
              definition.id)
            inputs
        in
        let output_feature_ids =
          List.map
            (fun output ->
              let definition =
                List.find
                  (fun (el :
                         'a
                         Sapiens_backend.Dataset.Datapoint.persisted_definition) ->
                    String.equal el.feature_name output)
                  definitions
              in
              definition.id)
            outputs
        in
        Sapiens_backend.Annotation.create_annotation_task
          ~as_:creator
          ~name:
            (Sapiens_backend.Annotation.Task.Name.of_string name
            |> Result.get_ok)
          ~datapoint_count:0
          ~input_feature_ids
          ~output_feature_ids
          ~assignee:user
          ?guidelines_url:guidelines
          dataset)
      tasks
  in
  Lwt.return_ok ()

let create_dataset info =
  let open Lwt_result.Syntax in
  let module Info = (val info : Dataset_intf.S) in
  Logs.info (fun m -> m "+ Creating user");
  let* user =
    get_user_or_create ~username:"tmattio" ~email:"thibaut.mattio@gmail.com"
  in
  Logs.info (fun m -> m "+ Creating dataset");
  let* dataset = force_create_dataset ~user ~name:Info.name in
  Logs.info (fun m -> m "+ Creating feature definitions");
  let* persisted_definitions =
    lwt_result_fold_left Info.definitions ~f:(fun (name, spec) ->
        let* name =
          Sapiens_backend.Dataset.Datapoint.Feature_name.of_string name
          |> Lwt_result.lift
        in
        Sapiens_backend.Dataset.create_dataset_feature_definition
          ~as_:user
          ~name
          ~definition:spec
          dataset)
  in
  let datapoints = Info.make_datapoints persisted_definitions in
  Logs.info (fun m -> m "+ Creating datapoints");
  let* _persisted_datapoints =
    lwt_result_fold_left
      ~f:(fun features ->
        Sapiens_backend.Dataset.create_dataset_datapoint
          ~as_:user
          ~features
          dataset)
      datapoints
  in
  Logs.info (fun m -> m "+ Creating collaborators");
  let* _ =
    match Info.collaborators with
    | Some collaborators ->
      add_collaborators dataset collaborators
    | None ->
      Lwt.return_ok ()
  in
  Logs.info (fun m -> m "+ Creating annotation tasks");
  let* _ =
    match Info.tasks with
    | Some tasks ->
      add_tasks ?guidelines:Info.guidelines dataset persisted_definitions tasks
    | None ->
      Lwt.return_ok ()
  in
  Lwt.return_ok ()
