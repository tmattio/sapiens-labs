module Task = Annotation_task
module Annotation = Annotation_annotation

module Error = struct
  type t =
    [ `Not_in_progress
    | Error.t
    ]
  [@@deriving show, eq]
end

module Progress = struct
  type t =
    { completed : int
    ; total : int
    }

  let compute t = float_of_int t.completed /. float_of_int t.total
end

let lwt_result_fold_left ~f l =
  let open Lwt_result.Syntax in
  let+ l =
    ListLabels.fold_left l ~init:(Lwt_result.return []) ~f:(fun acc el ->
        let* acc = acc in
        let+ result = f el in
        result :: acc)
  in
  List.rev l

let create_annotation_task
    ~as_
    ~name
    ~assignee
    ~datapoint_count:_
    ~input_feature_ids
    ~output_feature_ids
    ?guidelines_url
    dataset
  =
  let open Lwt_result.Syntax in
  match Dataset_permissions.can as_ `Create_annotation_task dataset with
  | true ->
    let* task =
      Annotation_task.create
        ~name
        ~creator:as_
        ~dataset
        ~input_feature_ids
        ~output_feature_ids
        ?guidelines_url
        ()
    in
    let* datapoints = Dataset_datapoint.get_by_dataset dataset in
    print_endline (Printf.sprintf "Got %d datapoints" (List.length datapoints));
    let* _ =
      lwt_result_fold_left
        datapoints
        ~f:(fun (datapoint : Dataset_datapoint.t) ->
          let features =
            List.filter
              (fun feature ->
                List.mem
                  (Dataset_datapoint.definition_id_of_feature feature)
                  output_feature_ids)
              datapoint.features
          in
          Annotation.create
            ~user_id:assignee.Account.User.id
            ~annotation_task_id:task.id
            ~datapoint_id:datapoint.id
            ~features)
    in
    Lwt.return_ok task
  | false ->
    Lwt.return_error `Permission_denied

let get_annotation_task_by_id ~as_ id =
  let open Lwt_result.Syntax in
  let* annotation_task = Annotation_task.get_by_id id in
  (* Ensure that the current user can index the dataset *)
  let* _ = Dataset.get_dataset_by_id ~as_ annotation_task.dataset_id in
  Lwt.return_ok annotation_task

let list_user_annotation_tasks ~as_ =
  Annotation_task.get_by_user_id ~state:In_progress as_.Account.User.id

let list_dataset_annotation_tasks ~as_ ~dataset =
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    Annotation_task.get_by_dataset_id dataset.Dataset.Dataset.id
  | false ->
    Lwt.return_error `Permission_denied

let cancel_annotation_task ~as_ annotation_task =
  let open Lwt_result.Syntax in
  let* dataset =
    Dataset.get_dataset_by_id ~as_ annotation_task.Annotation_task.dataset_id
  in
  match
    ( Dataset_permissions.can as_ `Cancel_annotation_task dataset
    , annotation_task.state )
  with
  | true, In_progress ->
    Annotation_task.cancel annotation_task
  | true, _ ->
    Lwt.return_error `Not_in_progress
  | false, _ ->
    Lwt.return_error `Permission_denied

let get_valid_features_from_annotations (annotations : Annotation.t list) =
  (* TODO: There is only one annotator per task for now, use annotator agreement
     score to select valid annotations when multi-annotators are supported *)
  annotations
  |> List.to_seq
  |> Seq.map (fun annotation ->
         let features =
           annotation.Annotation.annotations
           |> List.to_seq
           |> Seq.map (fun feature ->
                  Dataset_datapoint.definition_id_of_feature feature, feature)
           |> Hashtbl.of_seq
           |> Hashtbl.to_seq_values
           |> List.of_seq
         in
         annotation.datapoint_id, features)
  |> Hashtbl.of_seq
  |> Hashtbl.to_seq
  |> List.of_seq

let complete_annotation_task ~as_ annotation_task =
  let open Lwt_result.Syntax in
  let* dataset =
    Dataset.get_dataset_by_id ~as_ annotation_task.Annotation_task.dataset_id
  in
  match
    ( Dataset_permissions.can as_ `Cancel_annotation_task dataset
    , annotation_task.state )
  with
  | true, In_progress ->
    let* annotations =
      Annotation.get_by_annotation_task_id annotation_task.Task.id
    in
    let features = get_valid_features_from_annotations annotations in
    let* () = Dataset_datapoint.update_datapoints_features features in
    Annotation_task.complete annotation_task
  | true, _ ->
    Lwt.return_error `Not_in_progress
  | false, _ ->
    Lwt.return_error `Permission_denied

let annotate_datapoint ~user_id ~annotation_task_id ~datapoint_id features =
  let open Lwt_result.Syntax in
  let* annotation_id =
    Annotation.get_annotation_id ~user_id ~annotation_task_id ~datapoint_id
  in
  Annotation.update ~annotation_id ~features

let revert_annotation () = failwith "TODO"

let get_annotation_tasks_progress ~as_ ~dataset =
  match Dataset_permissions.can as_ `Index_dataset dataset with
  | true ->
    let open Lwt_result.Syntax in
    let request =
      [%rapper
        get_many
          {sql|
          SELECT @int{annotation_task_id}, @int{total}, @int{done}
          FROM annotation_task_statistics
          WHERE dataset_id = %int{dataset_id}
          |sql}]
    in
    let+ db_record =
      Repo.query (fun c -> request c ~dataset_id:dataset.Dataset.Dataset.id)
    in
    List.map
      (fun (id, total, completed) -> id, Progress.{ total; completed })
      db_record
  | false ->
    Lwt.return_error `Permission_denied

let get_annotation_tasks_user_progress ~user =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_many
        {sql|
        SELECT @int{annotation_task_id}, @int{user_total}, @int{user_done}
        FROM annotation_task_statistics
        WHERE user_id = %int{user_id}
        |sql}]
  in
  let+ db_record =
    Repo.query (fun c -> request c ~user_id:user.Account.User.id)
  in
  List.map
    (fun (id, total, completed) -> id, Progress.{ total; completed })
    db_record

let get_annotation_task_user_annotations ~user annotation_task =
  Annotation.get_by_user_id_and_annotation_task_id
    ~user_id:user.Account.User.id
    ~annotation_task_id:annotation_task.Task.id

let get_annotation_task_annotations annotation_task =
  Annotation.get_by_annotation_task_id annotation_task.Task.id
