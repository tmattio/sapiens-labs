include Sapiens_common.Annotation.Annotation

type feature_db_record =
  { annotation_id : int
  ; feature_definition_id : int
  ; feature_type : Dataset_datapoint.Feature_type.t
  ; feature : string
  }

let feature_of_db_record db_record : Dataset_datapoint.feature =
  let feature_json = db_record.feature |> Yojson.Safe.from_string in
  let decode_feature decoder =
    match decoder feature_json with
    | Ok r ->
      r
    | Error err ->
      failwith ("The feature has an invalid format: " ^ err)
  in
  let open Dataset_datapoint in
  match db_record.feature_type with
  | Feature_type.Image ->
    Image
      { feature = decode_feature Image.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Sequence Feature_type.Image ->
    Image_seq
      { feature = decode_feature Image.Feature.sequence_of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Text ->
    Text
      { feature = decode_feature Text.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Bbox ->
    Bbox
      { feature = decode_feature Bbox.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Sequence Feature_type.Bbox ->
    Bbox_seq
      { feature = decode_feature Bbox.Feature.sequence_of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Label ->
    Label
      { feature = decode_feature Label.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Sequence Feature_type.Label ->
    Label_seq
      { feature = decode_feature Label.Feature.sequence_of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Number ->
    Number
      { feature = decode_feature Number.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Sequence Feature_type.Number ->
    Number_seq
      { feature = decode_feature Number.Feature.sequence_of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Tokens ->
    Tokens
      { feature = decode_feature Tokens.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Entity ->
    Entity
      { feature = decode_feature Entity.Feature.of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | Feature_type.Sequence Feature_type.Entity ->
    Entity_seq
      { feature = decode_feature Entity.Feature.sequence_of_yojson
      ; definition_id = db_record.feature_definition_id
      }
  | _ ->
    failwith "Invalid feature type returned from the database."

let feature_of_rapper ~feature_definition_id ~feature_type ~feature =
  match feature_definition_id, feature_type, feature with
  | Some feature_definition_id, Some feature_type, Some feature ->
    Some { annotation_id = 0; feature_definition_id; feature_type; feature }
  | _ ->
    None

let query_annotations request =
  let open Lwt_result.Syntax in
  let* db_record =
    Repo.query (fun c ->
        request
          ( (fun ~id ~user_id ~annotation_task_id ~datapoint_id ~annotated_at ->
              { id
              ; user_id
              ; annotation_task_id
              ; datapoint_id
              ; input_features = []
              ; annotations = []
              ; annotated_at
              })
          , feature_of_rapper
          , feature_of_rapper )
          c)
  in
  let* annotations =
    try
      Lwt_result.return
      @@ Rapper.load_many
           ((fun (x, _, _) -> x), fun ({ id; _ } : t) -> id)
           [ ( (fun (_, x, _) -> x)
             , fun annotation annotations ->
                 { annotation with
                   annotations =
                     List.filter_map
                       (Option.map feature_of_db_record)
                       annotations
                 } )
           ; ( (fun (_, _, x) -> x)
             , fun annotation input_features ->
                 { annotation with
                   input_features =
                     List.filter_map
                       (Option.map feature_of_db_record)
                       input_features
                 } )
           ]
           db_record
    with
    | Failure s ->
      Lwt.return_error (`Internal_error s)
  in
  Lwt_result.return annotations

let get_by_user_id_and_annotation_task_id ~user_id ~annotation_task_id =
  let request =
    let open Dataset_datapoint in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{annotations.id},
          @int{annotations.user_id},
          @int{annotations.annotation_task_id},
          @int{annotations.datapoint_id},
          @ptime?{annotations.annotated_at},
          @int?{annotation_features.feature_definition_id},
          @Feature_type?{annotation_features.feature_type},
          @string?{annotation_features.feature},
          @int?{input_features.feature_definition_id},
          @Feature_type?{input_features.feature_type},
          @string?{input_features.feature}
        FROM annotations
        LEFT JOIN annotation_features ON annotation_features.annotation_id = annotations.id
        LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotations.annotation_task_id
        LEFT JOIN dataset_datapoint_features AS input_features ON 
          input_features.datapoint_id = annotations.datapoint_id AND 
          input_features.feature_definition_id = annotation_task_features.dataset_feature_definition_id AND 
          annotation_task_features.type = 'INPUT'
        WHERE annotations.annotation_task_id = %int{annotation_task_id} AND annotations.user_id = %int{user_id}
        ORDER BY annotations.id ASC, annotation_task_features.id ASC
        |sql}
        function_out]
      ~user_id
      ~annotation_task_id
  in
  query_annotations request

let get_by_annotation_task_id annotation_task_id =
  let request =
    let open Dataset_datapoint in
    [%rapper
      get_many
        {sql|
          SELECT
            @int{annotations.id},
            @int{annotations.user_id},
            @int{annotations.annotation_task_id},
            @int{annotations.datapoint_id},
            @ptime?{annotations.annotated_at},
            @int?{annotation_features.feature_definition_id},
            @Feature_type?{annotation_features.feature_type},
            @string?{annotation_features.feature},
            @int?{input_features.feature_definition_id},
            @Feature_type?{input_features.feature_type},
            @string?{input_features.feature}
          FROM annotations
          LEFT JOIN annotation_features ON annotation_features.annotation_id = annotations.id
          LEFT JOIN annotation_task_features ON annotation_task_features.annotation_task_id = annotations.annotation_task_id
          LEFT JOIN dataset_datapoint_features AS input_features ON 
            input_features.datapoint_id = annotations.datapoint_id AND 
            input_features.feature_definition_id = annotation_task_features.dataset_feature_definition_id AND 
            annotation_task_features.type = 'INPUT'
          WHERE annotations.annotation_task_id = %int{annotation_task_id}
          ORDER BY annotations.id ASC, annotation_task_features.id ASC
          |sql}
        function_out]
      ~annotation_task_id
  in
  query_annotations request

let lwt_result_fold_left ~f l =
  let open Lwt_result.Syntax in
  let+ l =
    ListLabels.fold_left l ~init:(Lwt_result.return []) ~f:(fun acc el ->
        let* acc = acc in
        let+ result = f el in
        result :: acc)
  in
  List.rev l

let create
    ~user_id
    ~annotation_task_id
    ~datapoint_id
    ~(features : Dataset_datapoint.feature list)
  =
  let open Lwt_result.Syntax in
  let open Dataset_datapoint in
  let create_annotation_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO annotations (user_id, datapoint_id, annotation_task_id)
        VALUES (%int{user_id}, %int{datapoint_id}, %int{annotation_task_id})
        RETURNING @int{id}
        |sql}]
  in
  let create_feature_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO annotation_features (annotation_id, feature_definition_id, feature_type, feature)
        VALUES (%int{annotation_id}, %int{feature_definition_id}, %Feature_type{feature_type}, %string{feature})
        RETURNING
          @int{annotation_id},
          @int{feature_definition_id},
          @Feature_type{feature_type},
          @string{feature}
        |sql}
        record_out]
  in
  let* _result =
    Repo.transaction (fun c ->
        let* annotation_id =
          create_annotation_request c ~user_id ~datapoint_id ~annotation_task_id
        in
        lwt_result_fold_left features ~f:(fun el ->
            let db_record =
              { annotation_id
              ; feature_definition_id = definition_id_of_feature el
              ; feature_type = feature_type_of_feature el
              ; feature = encode_feature el
              }
            in
            create_feature_request
              ~annotation_id
              ~feature_definition_id:db_record.feature_definition_id
              ~feature_type:db_record.feature_type
              ~feature:db_record.feature
              c))
  in
  Lwt_result.return ()

let get_annotation_id ~user_id ~annotation_task_id ~datapoint_id =
  let request =
    [%rapper
      get_opt
        {sql| 
        SELECT @int{id}
        FROM annotations 
        WHERE annotations.user_id = %int{user_id} AND annotations.datapoint_id = %int{datapoint_id} AND annotations.annotation_task_id = %int{annotation_task_id}
        |sql}]
      ~user_id
      ~annotation_task_id
      ~datapoint_id
  in
  Repo.query_opt (fun c -> request c)

let update ~annotation_id ~(features : Dataset_datapoint.feature list) =
  let open Lwt_result.Syntax in
  let open Dataset_datapoint in
  let update_annotated_at =
    [%rapper
      execute
        {sql| 
        UPDATE annotations 
        SET annotated_at = now()
        WHERE annotations.id = %int{annotation_id}
        |sql}]
      ~annotation_id
  in
  let delete_annotation_request =
    [%rapper
      execute
        {sql| 
        DELETE FROM annotation_features 
        WHERE annotation_features.annotation_id = %int{annotation_id}
        |sql}]
      ~annotation_id
  in
  let create_feature_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO annotation_features (annotation_id, feature_definition_id, feature_type, feature)
        VALUES (%int{annotation_id}, %int{feature_definition_id}, %Feature_type{feature_type}, %string{feature})
        RETURNING
          @int{annotation_id},
          @int{feature_definition_id},
          @Feature_type{feature_type},
          @string{feature}
        |sql}
        record_out]
  in
  let* _result =
    Repo.transaction (fun c ->
        let* () = update_annotated_at c in
        let* () = delete_annotation_request c in
        lwt_result_fold_left features ~f:(fun el ->
            let db_record =
              { annotation_id
              ; feature_definition_id = definition_id_of_feature el
              ; feature_type = feature_type_of_feature el
              ; feature = encode_feature el
              }
            in
            create_feature_request
              ~annotation_id
              ~feature_definition_id:db_record.feature_definition_id
              ~feature_type:db_record.feature_type
              ~feature:db_record.feature
              c))
  in
  Lwt_result.return ()
