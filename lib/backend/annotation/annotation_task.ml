let lwt_result_fold_left ~f l =
  let open Lwt_result.Syntax in
  let+ l =
    ListLabels.fold_left l ~init:(Lwt_result.return []) ~f:(fun acc el ->
        let* acc = acc in
        let+ result = f el in
        result :: acc)
  in
  List.rev l

module State = struct
  type t =
    | In_progress
    | Completed
    | Canceled
  [@@deriving show]

  let t =
    let encode = function
      | In_progress ->
        Ok "IN_PROGRESS"
      | Completed ->
        Ok "COMPLETED"
      | Canceled ->
        Ok "CANCELED"
    in
    let decode = function
      | "IN_PROGRESS" ->
        Ok In_progress
      | "COMPLETED" ->
        Ok Completed
      | "CANCELED" ->
        Ok Canceled
      | _ ->
        Error "invalid feature type"
    in
    Caqti_type.(custom ~encode ~decode string)
end

module Name = Helper.Make_field (struct
  type t = string [@@deriving show, eq]

  let caqti_type = Caqti_type.string

  let validate s =
    let open Std.Result.Syntax in
    let* _ = Helper.validate_string_length ~name:"name" ~max:60 s in
    Ok s
end)

type t =
  { id : int
  ; name : Name.t
  ; guidelines_url : string option
  ; creator_id : int
  ; dataset_id : int
  ; input_features : Dataset_datapoint.definition list
  ; output_features : Dataset_datapoint.definition list
  ; state : State.t
  ; created_at : Ptime.t
  }
[@@deriving show]

type definition_db_record =
  { definition : string
  ; feature_type : Dataset_datapoint.Feature_type.t
  ; feature_name : Dataset_datapoint.Feature_name.t
  ; id : int
  ; dataset_id : int
  }

let annotation_task_of_rapper
    ~id ~creator_id ~dataset_id ~name ~guidelines_url ~state ~created_at
  =
  { id
  ; name
  ; guidelines_url
  ; creator_id
  ; dataset_id
  ; input_features = []
  ; output_features = []
  ; state
  ; created_at
  }

let definition_of_rapper ~id ~dataset_id ~feature_name ~feature_type ~definition
  =
  match id, dataset_id, feature_name, feature_type, definition with
  | ( Some id
    , Some dataset_id
    , Some feature_name
    , Some feature_type
    , Some definition ) ->
    Some { id; dataset_id; feature_name; feature_type; definition }
  | Some id, _, _, _, _ ->
    Logs.info (fun m -> m "Skipping definition with ID %d" id);
    None
  | _ ->
    None

let definition_of_db_record
    { definition; feature_type; feature_name; id; dataset_id }
  =
  { Sapiens_common.Datapoint.id
  ; dataset_id
  ; feature_name
  ; spec =
      Sapiens_common.Datapoint.decode_definition_spec ~feature_type definition
  }

let get_many_from_request request =
  let open Lwt_result.Syntax in
  let+ db_record =
    Repo.query (fun c ->
        request
          (annotation_task_of_rapper, definition_of_rapper, definition_of_rapper)
          c)
  in
  Rapper.load_many
    ((fun (x, _, _) -> x), fun ({ id; _ } : t) -> id)
    [ ( (fun (_, x, _) -> x)
      , fun task input_features ->
          { task with
            input_features =
              List.filter_map
                (Option.map definition_of_db_record)
                input_features
          } )
    ; ( (fun (_, _, x) -> x)
      , fun task output_features ->
          { task with
            output_features =
              List.filter_map
                (Option.map definition_of_db_record)
                output_features
          } )
    ]
    db_record

let get_one_from_request request =
  let open Lwt_result.Syntax in
  let* tasks = get_many_from_request request in
  match tasks with
  | [] ->
    Lwt.return_error `Not_found
  | [ el ] ->
    Lwt.return_ok el
  | _ ->
    Lwt.return_error
      (`Internal_error "Got multiple tasks, only one was expected")

let get_by_id id =
  let request =
    let open Dataset_datapoint in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{annotation_tasks.id},
          @int{annotation_tasks.creator_id},
          @int{annotation_tasks.dataset_id},
          @Name{annotation_tasks.name},
          @string?{annotation_tasks.guidelines_url},
          @State{annotation_tasks.state},
          @ptime{annotation_tasks.created_at},
          @int?{input_features.id},
          @int?{input_features.dataset_id},
          @Feature_name?{input_features.feature_name},
          @Feature_type?{input_features.feature_type},
          @string?{input_features.definition},
          @int?{output_features.id},
          @int?{output_features.dataset_id},
          @Feature_name?{output_features.feature_name},
          @Feature_type?{output_features.feature_type},
          @string?{output_features.definition}
        FROM annotation_tasks
        LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotation_tasks.id 
        LEFT JOIN dataset_feature_definitions AS input_features ON annotation_task_features.dataset_feature_definition_id = input_features.id AND annotation_task_features.type = 'INPUT'
        LEFT JOIN dataset_feature_definitions AS output_features ON annotation_task_features.dataset_feature_definition_id = output_features.id AND annotation_task_features.type = 'OUTPUT'
        WHERE annotation_tasks.id = %int{id} 
        ORDER BY annotation_tasks.id ASC
        |sql}
        function_out]
      ~id
  in
  get_one_from_request request

let get_by_user_id ?state user_id =
  let request =
    let open Dataset_datapoint in
    match state with
    | Some state ->
      [%rapper
        get_many
          {sql|
          SELECT
            @int{annotation_tasks.id},
            @int{annotation_tasks.creator_id},
            @int{annotation_tasks.dataset_id},
            @Name{annotation_tasks.name},
            @string?{annotation_tasks.guidelines_url},
            @State{annotation_tasks.state},
            @ptime{annotation_tasks.created_at},
            @int?{input_features.id},
            @int?{input_features.dataset_id},
            @Feature_name?{input_features.feature_name},
            @Feature_type?{input_features.feature_type},
            @string?{input_features.definition},
            @int?{output_features.id},
            @int?{output_features.dataset_id},
            @Feature_name?{output_features.feature_name},
            @Feature_type?{output_features.feature_type},
            @string?{output_features.definition}
          FROM annotation_tasks
          LEFT JOIN annotations ON annotations.annotation_task_id = annotation_tasks.id
          LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotation_tasks.id 
          LEFT JOIN dataset_feature_definitions AS input_features ON annotation_task_features.dataset_feature_definition_id = input_features.id AND annotation_task_features.type = 'INPUT'
          LEFT JOIN dataset_feature_definitions AS output_features ON annotation_task_features.dataset_feature_definition_id = output_features.id AND annotation_task_features.type = 'OUTPUT'
          WHERE annotations.user_id = %int{user_id} AND annotation_tasks.state = %State{state}
          ORDER BY annotation_tasks.id ASC
          |sql}
          function_out]
        ~user_id
        ~state
    | None ->
      [%rapper
        get_many
          {sql|
          SELECT
            @int{annotation_tasks.id},
            @int{annotation_tasks.creator_id},
            @int{annotation_tasks.dataset_id},
            @Name{annotation_tasks.name},
            @string?{annotation_tasks.guidelines_url},
            @State{annotation_tasks.state},
            @ptime{annotation_tasks.created_at},
            @int?{input_features.id},
            @int?{input_features.dataset_id},
            @Feature_name?{input_features.feature_name},
            @Feature_type?{input_features.feature_type},
            @string?{input_features.definition},
            @int?{output_features.id},
            @int?{output_features.dataset_id},
            @Feature_name?{output_features.feature_name},
            @Feature_type?{output_features.feature_type},
            @string?{output_features.definition}
          FROM annotation_tasks
          LEFT JOIN annotations ON annotations.annotation_task_id = annotation_tasks.id
          LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotation_tasks.id 
          LEFT JOIN dataset_feature_definitions AS input_features ON annotation_task_features.dataset_feature_definition_id = input_features.id AND annotation_task_features.type = 'INPUT'
          LEFT JOIN dataset_feature_definitions AS output_features ON annotation_task_features.dataset_feature_definition_id = output_features.id AND annotation_task_features.type = 'OUTPUT'
          WHERE annotations.user_id = %int{user_id}
          ORDER BY annotation_tasks.id ASC
          |sql}
          function_out]
        ~user_id
  in
  get_many_from_request request

let get_by_dataset_id ?state dataset_id =
  let request =
    let open Dataset_datapoint in
    match state with
    | Some state ->
      [%rapper
        get_many
          {sql|
          SELECT 
            @int{annotation_tasks.id},
            @int{annotation_tasks.creator_id},
            @int{annotation_tasks.dataset_id},
            @Name{annotation_tasks.name},
            @string?{annotation_tasks.guidelines_url},
            @State{annotation_tasks.state},
            @ptime{annotation_tasks.created_at},
            @int?{input_features.id},
            @int?{input_features.dataset_id},
            @Feature_name?{input_features.feature_name},
            @Feature_type?{input_features.feature_type},
            @string?{input_features.definition},
            @int?{output_features.id},
            @int?{output_features.dataset_id},
            @Feature_name?{output_features.feature_name},
            @Feature_type?{output_features.feature_type},
            @string?{output_features.definition}
          FROM annotation_tasks
          LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotation_tasks.id 
          LEFT JOIN dataset_feature_definitions AS input_features ON annotation_task_features.dataset_feature_definition_id = input_features.id AND annotation_task_features.type = 'INPUT'
          LEFT JOIN dataset_feature_definitions AS output_features ON annotation_task_features.dataset_feature_definition_id = output_features.id AND annotation_task_features.type = 'OUTPUT'
          WHERE annotation_tasks.dataset_id = %int{dataset_id} AND annotation_tasks.state = %State{state}
          ORDER BY annotation_tasks.id ASC
          |sql}
          function_out]
        ~dataset_id
        ~state
    | None ->
      [%rapper
        get_many
          {sql|
          SELECT 
            @int{annotation_tasks.id},
            @int{annotation_tasks.creator_id},
            @int{annotation_tasks.dataset_id},
            @Name{annotation_tasks.name},
            @string?{annotation_tasks.guidelines_url},
            @State{annotation_tasks.state},
            @ptime{annotation_tasks.created_at},
            @int?{input_features.id},
            @int?{input_features.dataset_id},
            @Feature_name?{input_features.feature_name},
            @Feature_type?{input_features.feature_type},
            @string?{input_features.definition},
            @int?{output_features.id},
            @int?{output_features.dataset_id},
            @Feature_name?{output_features.feature_name},
            @Feature_type?{output_features.feature_type},
            @string?{output_features.definition}
          FROM annotation_tasks
          LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotation_tasks.id 
          LEFT JOIN dataset_feature_definitions AS input_features ON annotation_task_features.dataset_feature_definition_id = input_features.id AND annotation_task_features.type = 'INPUT'
          LEFT JOIN dataset_feature_definitions AS output_features ON annotation_task_features.dataset_feature_definition_id = output_features.id AND annotation_task_features.type = 'OUTPUT'
          WHERE annotation_tasks.dataset_id = %int{dataset_id}
          ORDER BY annotation_tasks.id ASC
          |sql}
          function_out]
        ~dataset_id
  in
  get_many_from_request request

let create
    ~name
    ~(creator : Account.User.t)
    ~(dataset : Dataset.Dataset.t)
    ~input_feature_ids
    ~output_feature_ids
    ?guidelines_url
    ()
  =
  let open Lwt_result.Syntax in
  let create_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO annotation_tasks (name, guidelines_url, creator_id, dataset_id, state)
        VALUES (%Name{name}, %string?{guidelines_url}, %int{creator_id}, %int{dataset_id}, 'IN_PROGRESS')
        RETURNING @int{id}
        |sql}]
  in
  let* task_id =
    Repo.query (fun c ->
        create_request
          c
          ~name
          ~creator_id:creator.id
          ~dataset_id:dataset.id
          ~guidelines_url)
  in
  let create_definition_request =
    [%rapper
      execute
        {sql| 
        INSERT INTO annotation_task_features (dataset_feature_definition_id, annotation_task_id, type)
        VALUES (%int{definition_id}, %int{task_id}, %string{type_})
        |sql}]
      ~task_id
  in
  let* _ =
    lwt_result_fold_left
      ~f:(fun id ->
        Repo.query (fun c ->
            create_definition_request c ~definition_id:id ~type_:"INPUT"))
      input_feature_ids
  in
  let* _ =
    lwt_result_fold_left
      ~f:(fun id ->
        Repo.query (fun c ->
            create_definition_request c ~definition_id:id ~type_:"OUTPUT"))
      output_feature_ids
  in
  Lwt_result.map_err
    (function
      | `Not_found ->
        `Internal_error "The task could not be found after creation"
      | `Internal_error _ as err ->
        err)
    (get_by_id task_id)

let complete (t : t) =
  let request =
    [%rapper
      execute
        {sql|
        UPDATE annotation_tasks SET state = 'COMPLETED'
        WHERE annotation_tasks.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)

let cancel (t : t) =
  let request =
    [%rapper
      execute
        {sql|
        UPDATE annotation_tasks SET state = 'CANCELED'
        WHERE annotation_tasks.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)
