include Sapiens_common.Datapoint

module Dynparam = struct
  type t = Pack : 'a Caqti_type.t * 'a -> t

  let empty = Pack (Caqti_type.unit, ())

  let add t x (Pack (t', x')) = Pack (Caqti_type.tup2 t' t, (x', x))
end

let batch_list n l =
  let list_stream =
    let open Streaming.Stream.Syntax in
    let* s = Streaming.Stream.of_list l |> Streaming.Stream.partition n in
    yield @@ Streaming.Stream.to_list s
  in
  let batches = Streaming.Stream.to_list list_stream in
  batches

let lwt_result_fold_left ~f l =
  let open Lwt_result.Syntax in
  let+ l =
    ListLabels.fold_left l ~init:(Lwt_result.return []) ~f:(fun acc el ->
        let* acc = acc in
        let+ result = f el in
        result :: acc)
  in
  List.rev l

module Feature_type = struct
  include Sapiens_common.Datapoint.Feature_type

  let t =
    let rec encode = function
      | Feature_type.Image ->
        Ok "IMAGE"
      | Text ->
        Ok "TEXT"
      | Bbox ->
        Ok "BBOX"
      | Label ->
        Ok "LABEL"
      | Number ->
        Ok "NUMBER"
      | Tokens ->
        Ok "TOKENS"
      | Entity ->
        Ok "ENTITY"
      | Sequence feat ->
        let open Std.Result.Syntax in
        let* s = encode feat in
        Ok (s ^ "_SEQ")
    in
    let rec decode = function
      | "IMAGE" ->
        Ok Feature_type.Image
      | "TEXT" ->
        Ok Text
      | "BBOX" ->
        Ok Bbox
      | "LABEL" ->
        Ok Label
      | "NUMBER" ->
        Ok Number
      | "TOKENS" ->
        Ok Tokens
      | "ENTITY" ->
        Ok Entity
      | s
        when Std.String.equal
               "_SEQ"
               (Std.String.sub s ~pos:(String.length s - 4) ~len:4) ->
        let open Std.Result.Syntax in
        let feat_name = Std.String.sub s ~pos:0 ~len:(String.length s - 4) in
        let* f = decode feat_name in
        Ok (Sequence f)
      | _ ->
        Error "invalid feature type"
    in
    Caqti_type.(custom ~encode ~decode string)
end

module Split = struct
  include Sapiens_common.Datapoint.Split

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok (to_string x))
        Caqti_type.string)
end

module Feature_name = struct
  include Sapiens_common.Datapoint.Feature_name

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok (to_string x))
        string)
end

type feature_db_record =
  { datapoint_id : int
  ; feature_definition_id : int
  ; feature_type : Feature_type.t
  ; feature : string
  }

type definition_db_record =
  { definition : string
  ; feature_type : Feature_type.t
  ; feature_name : Feature_name.t
  ; id : int
  ; dataset_id : int
  }

let feature_of_db_record db_record : feature =
  let feature_json = db_record.feature |> Yojson.Safe.from_string in
  let decode_feature decoder =
    match decoder feature_json with
    | Ok r ->
      r
    | Error err ->
      failwith ("The feature has an invalid format: " ^ err)
  in
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

let feature_to_db_record ~datapoint_id (feature : feature) : feature_db_record =
  let encoded_feature = encode_feature feature in
  let db_record_with_feature_type feature_type =
    { datapoint_id
    ; feature_definition_id = definition_id_of_feature feature
    ; feature_type
    ; feature = encoded_feature
    }
  in
  match feature with
  | Image _ ->
    db_record_with_feature_type Feature_type.Image
  | Image_seq _ ->
    db_record_with_feature_type (Feature_type.Sequence Feature_type.Image)
  | Text _ ->
    db_record_with_feature_type Feature_type.Text
  | Bbox _ ->
    db_record_with_feature_type Feature_type.Bbox
  | Bbox_seq _ ->
    db_record_with_feature_type (Feature_type.Sequence Feature_type.Bbox)
  | Label _ ->
    db_record_with_feature_type Feature_type.Label
  | Label_seq _ ->
    db_record_with_feature_type (Feature_type.Sequence Feature_type.Label)
  | Number _ ->
    db_record_with_feature_type Feature_type.Number
  | Number_seq _ ->
    db_record_with_feature_type (Feature_type.Sequence Feature_type.Number)
  | Tokens _ ->
    db_record_with_feature_type Feature_type.Tokens
  | Entity _ ->
    db_record_with_feature_type Feature_type.Entity
  | Entity_seq _ ->
    db_record_with_feature_type (Feature_type.Sequence Feature_type.Entity)

let definition_of_db_record
    { definition; feature_type; feature_name; id; dataset_id }
  =
  { id
  ; dataset_id
  ; feature_name
  ; spec = decode_definition_spec ~feature_type definition
  }

let get_definition_by_id id =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_one
        {sql|
        SELECT
          @int{id},
          @int{dataset_id},
          @Feature_name{feature_name},
          @Feature_type{feature_type},
          @string{definition}
        FROM dataset_feature_definitions
        WHERE id = %int{id}
        |sql}
        record_out]
  in
  let* db_record = Repo.query (fun c -> request ~id c) in
  try Lwt.return_ok (definition_of_db_record db_record) with
  | Failure s ->
    Lwt.return_error (`Internal_error s)

let get_definitions_by_dataset dataset =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_many
        {sql|
            SELECT
              @int{id},
              @int{dataset_id},
              @Feature_name{feature_name},
              @Feature_type{feature_type},
              @string{definition}
            FROM dataset_feature_definitions
            WHERE dataset_id = %int{dataset_id}
            |sql}
        record_out]
  in
  let* db_records =
    Repo.query (fun c -> request ~dataset_id:dataset.Dataset_dataset.id c)
  in
  try
    Lwt.return
      (Ok
         (List.map
            (fun db_record -> definition_of_db_record db_record)
            db_records))
  with
  | Failure s ->
    Lwt.return_error (`Internal_error s)

let create_definition ~dataset ~name spec =
  let open Lwt_result.Syntax in
  let db_record_in =
    { feature_type = feature_type_of_definition_spec spec
    ; feature_name = name
    ; id = 0
    ; dataset_id = dataset.Dataset_dataset.id
    ; definition = encode_definition_spec spec
    }
  in
  let request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO dataset_feature_definitions (dataset_id, feature_name, feature_type, definition)
        VALUES (%int{dataset_id}, %Feature_name{feature_name}, %Feature_type{feature_type}, %string{definition})
        RETURNING
          @int{id},
          @int{dataset_id},
          @Feature_name{feature_name},
          @Feature_type{feature_type},
          @string{definition}
        |sql}
        record_in
        record_out]
    [@@warning "-9"]
  in
  let* db_record_out = Repo.query (fun c -> request db_record_in c) in
  try Lwt.return (Ok (definition_of_db_record db_record_out)) with
  | Failure s ->
    Lwt.return_error (`Internal_error s)

let insert_definitions (module DB : Caqti_lwt.CONNECTION) fields =
  let placeholders =
    List.map (fun _ -> "(?, ?, ?, ?)") fields |> String.concat ", "
  in
  let (Dynparam.Pack (typ, values)) =
    List.fold_left
      (fun pack (el : definition_db_record) ->
        Dynparam.add
          Caqti_type.(tup4 int string Feature_type.t string)
          (el.dataset_id, el.feature_name, el.feature_type, el.definition)
          pack)
      Dynparam.empty
      fields
  in
  let sql =
    Printf.sprintf
      "INSERT INTO dataset_feature_definitions (dataset_id, feature_name, \
       feature_type, definition) VALUES %s"
      placeholders
  in
  let query = Caqti_request.exec ~oneshot:true typ sql in
  DB.exec query values

let create_definitions_in_batch ~dataset name_to_spec =
  let db_records_in =
    List.map
      (fun (name, spec) ->
        { feature_type = feature_type_of_definition_spec spec
        ; feature_name = name
        ; id = 0
        ; dataset_id = dataset.Dataset_dataset.id
        ; definition = encode_definition_spec spec
        })
      name_to_spec
  in
  let batches = batch_list 100 db_records_in in
  let open Lwt_result.Syntax in
  let* _ =
    Repo.transaction (fun c ->
        lwt_result_fold_left batches ~f:(insert_definitions c))
  in
  Lwt.return_ok ()

let update_definition ?name ?spec (t : 'a persisted_definition) =
  let open Lwt_result.Syntax in
  let feature_name =
    Option.value name ~default:(feature_name_of_definition t)
  in
  let db_record_in =
    match spec with
    | Some spec ->
      { feature_type = feature_type_of_definition_spec spec
      ; feature_name
      ; id = id_of_definition t
      ; dataset_id = dataset_id_of_definition t
      ; definition = encode_definition_spec spec
      }
    | None ->
      { feature_type = feature_type_of_definition_spec t.spec
      ; feature_name
      ; id = id_of_definition t
      ; dataset_id = dataset_id_of_definition t
      ; definition = encode_definition_spec t.spec
      }
  in
  let request =
    [%rapper
      get_one
        {sql| 
        UPDATE dataset_feature_definitions SET
          dataset_id = %int{dataset_id},
          feature_name = %Feature_name{feature_name},
          feature_type = %Feature_type{feature_type},
          definition = %string{definition}
        WHERE dataset_feature_definitions.id = %int{id}
        RETURNING
          @int{id},
          @int{dataset_id},
          @Feature_name{feature_name},
          @Feature_type{feature_type},
          @string{definition}
        |sql}
        record_in
        record_out]
  in
  let* db_record_out = Repo.query (fun c -> request db_record_in c) in
  try Lwt.return (Ok (definition_of_db_record db_record_out)) with
  | Failure s ->
    Lwt.return_error (`Internal_error s)

let delete_definition (t : 'a persisted_definition) =
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM dataset_feature_definitions
        WHERE dataset_feature_definitions.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:(id_of_definition t))

let get_by_id datapoint_id =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_many
        {sql|
        SELECT
          @int{dataset_datapoints.id},
          @int{dataset_datapoints.dataset_id},
          @Split?{dataset_datapoints.split},
          @int{dataset_datapoint_features.feature_definition_id},
          @Feature_type{dataset_datapoint_features.feature_type},
          @string{dataset_datapoint_features.feature}
        FROM dataset_datapoints
        JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
        WHERE dataset_datapoints.id = %int{id}
        ORDER BY dataset_datapoints.id ASC
        |sql}
        function_out]
  in
  let* db_record =
    Repo.query (fun c ->
        request
          ( (fun ~id ~dataset_id ~split ->
              { id; dataset_id; split; features = [] })
          , fun ~feature_definition_id ~feature_type ~feature ->
              { datapoint_id; feature_definition_id; feature_type; feature } )
          ~id:datapoint_id
          c)
  in
  let* datapoints =
    try
      Lwt_result.return
      @@ Rapper.load_many
           (fst, fun ({ id; _ } : t) -> id)
           [ ( snd
             , fun datapoint features ->
                 { datapoint with
                   features = List.map feature_of_db_record features
                 } )
           ]
           db_record
    with
    | Failure s ->
      Lwt.return_error (`Internal_error s)
  in
  let* datapoint =
    try Lwt_result.return @@ List.hd datapoints with
    | Failure s ->
      Lwt.return_error (`Internal_error s)
  in
  Lwt_result.return datapoint

let get_by_dataset ?limit ?offset ?split dataset =
  let open Lwt_result.Syntax in
  let request =
    match split, limit with
    | Some split, Some i ->
      [%rapper
        get_many
          {sql|
          SELECT
            @int{dataset_datapoints.id},
            @int{dataset_datapoints.dataset_id},
            @Split?{dataset_datapoints.split},
            @int{dataset_datapoint_features.feature_definition_id},
            @Feature_type{dataset_datapoint_features.feature_type},
            @string{dataset_datapoint_features.feature}
          FROM dataset_datapoints
          JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
          WHERE dataset_datapoints.id IN (
            SELECT dataset_datapoints.id
            FROM dataset_datapoints
            WHERE dataset_datapoints.dataset_id = %int{dataset_id} 
            AND dataset_datapoints.split LIKE %string{dataset_split} 
            LIMIT %int{limit}
            OFFSET %int{offset}
          )
          ORDER BY dataset_datapoints.id ASC
          |sql}
          function_out]
        ~dataset_id:dataset.Dataset_dataset.id
        ~dataset_split:split
        ~offset:(Option.value offset ~default:0)
        ~limit:i
    | None, Some i ->
      [%rapper
        get_many
          {sql|
              SELECT
                @int{dataset_datapoints.id},
                @int{dataset_datapoints.dataset_id},
                @Split?{dataset_datapoints.split},
                @int{dataset_datapoint_features.feature_definition_id},
                @Feature_type{dataset_datapoint_features.feature_type},
                @string{dataset_datapoint_features.feature}
              FROM dataset_datapoints
              JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
              WHERE dataset_datapoints.id IN (
                SELECT dataset_datapoints.id
                FROM dataset_datapoints
                WHERE dataset_datapoints.dataset_id = %int{dataset_id} 
                LIMIT %int{limit}
                OFFSET %int{offset}
              )
              ORDER BY dataset_datapoints.id ASC
              |sql}
          function_out]
        ~dataset_id:dataset.Dataset_dataset.id
        ~offset:(Option.value offset ~default:0)
        ~limit:i
    | Some split, None ->
      [%rapper
        get_many
          {sql|
              SELECT
                @int{dataset_datapoints.id},
                @int{dataset_datapoints.dataset_id},
                @Split?{dataset_datapoints.split},
                @int{dataset_datapoint_features.feature_definition_id},
                @Feature_type{dataset_datapoint_features.feature_type},
                @string{dataset_datapoint_features.feature}
              FROM dataset_datapoints
              JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
              WHERE dataset_datapoints.dataset_id = %int{dataset_id} 
              AND dataset_datapoints.split LIKE %string{dataset_split} 
              ORDER BY dataset_datapoints.id ASC
              OFFSET %int{offset}
              |sql}
          function_out]
        ~dataset_id:dataset.Dataset_dataset.id
        ~dataset_split:split
        ~offset:(Option.value offset ~default:0)
    | None, None ->
      [%rapper
        get_many
          {sql|
          SELECT
            @int{dataset_datapoints.id},
            @int{dataset_datapoints.dataset_id},
            @Split?{dataset_datapoints.split},
            @int{dataset_datapoint_features.feature_definition_id},
            @Feature_type{dataset_datapoint_features.feature_type},
            @string{dataset_datapoint_features.feature}
          FROM dataset_datapoints
          JOIN dataset_datapoint_features ON dataset_datapoint_features.datapoint_id = dataset_datapoints.id
          WHERE dataset_datapoints.dataset_id = %int{dataset_id} 
          ORDER BY dataset_datapoints.id ASC
          OFFSET %int{offset}
          |sql}
          function_out]
        ~dataset_id:dataset.Dataset_dataset.id
        ~offset:(Option.value offset ~default:0)
  in
  let* db_record =
    Repo.query (fun c ->
        request
          ( (fun ~id ~dataset_id ~split ->
              { id; dataset_id; split; features = [] })
          , fun ~feature_definition_id ~feature_type ~feature ->
              { datapoint_id = 0; feature_definition_id; feature_type; feature }
          )
          c)
  in
  let* datapoints =
    try
      Lwt_result.return
      @@ Rapper.load_many
           (fst, fun ({ id; _ } : t) -> id)
           [ ( snd
             , fun datapoint features ->
                 { datapoint with
                   features = List.map feature_of_db_record features
                 } )
           ]
           db_record
    with
    | Failure s ->
      Lwt.return_error (`Internal_error s)
  in
  Lwt_result.return datapoints

let create ~dataset ~(features : feature list) ?split () =
  let open Lwt_result.Syntax in
  let create_datapoint_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO dataset_datapoints (dataset_id, split)
        VALUES (%int{dataset_id}, %Split?{split})
        RETURNING @int{id}, @int{dataset_id}, @Split?{split}
        |sql}]
  in
  let create_feature_request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO dataset_datapoint_features (datapoint_id, feature_definition_id, feature_type, feature)
        VALUES (%int{datapoint_id}, %int{feature_definition_id}, %Feature_type{feature_type}, %string{feature})
        RETURNING
          @int{datapoint_id},
          @int{feature_definition_id},
          @Feature_type{feature_type},
          @string{feature}
        |sql}
        record_out]
  in
  Repo.transaction (fun c ->
      let* datapoint_id, dataset_id, split =
        create_datapoint_request c ~dataset_id:dataset.Dataset_dataset.id ~split
      in
      let* features =
        lwt_result_fold_left features ~f:(fun el ->
            let db_record =
              { datapoint_id
              ; feature_definition_id = definition_id_of_feature el
              ; feature_type = feature_type_of_feature el
              ; feature = encode_feature el
              }
            in
            create_feature_request
              ~datapoint_id
              ~feature_definition_id:db_record.feature_definition_id
              ~feature_type:db_record.feature_type
              ~feature:db_record.feature
              c)
      in
      Lwt_result.return
        ({ id = datapoint_id
         ; dataset_id
         ; split
         ; features = List.map feature_of_db_record features
         }
          : t))

let delete (t : t) =
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM dataset_datapoints
        WHERE dataset_datapoints.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)

let upsert_features (module DB : Caqti_lwt.CONNECTION) fields =
  let placeholders =
    List.map (fun _ -> "(?, ?, ?, ?)") fields |> String.concat ", "
  in
  let (Dynparam.Pack (typ, values)) =
    List.fold_left
      (fun pack (feature : feature_db_record) ->
        Dynparam.add
          Caqti_type.(tup4 int int Feature_type.t string)
          ( feature.datapoint_id
          , feature.feature_definition_id
          , feature.feature_type
          , feature.feature )
          pack)
      Dynparam.empty
      fields
  in
  let sql =
    Printf.sprintf
      "INSERT INTO dataset_datapoint_features (datapoint_id, \
       feature_definition_id, feature_type, feature) VALUES %s ON CONFLICT \
       (datapoint_id, feature_definition_id) DO UPDATE SET \
       feature_type=EXCLUDED.feature_type, feature=EXCLUDED.feature"
      placeholders
  in
  let query = Caqti_request.exec ~oneshot:true typ sql in
  DB.exec query values

let update_datapoints_features
    (datapoint_id_to_features : (int * feature list) list)
  =
  let db_record_stream =
    let open Streaming.Stream.Syntax in
    let* datapoint_id, features =
      Streaming.Stream.of_list datapoint_id_to_features
    in
    let* feature = Streaming.Stream.of_list features in
    yield @@ feature_to_db_record ~datapoint_id feature
  in
  let list_stream =
    let open Streaming.Stream.Syntax in
    let* s = Streaming.Stream.partition 100 db_record_stream in
    yield @@ Streaming.Stream.to_list s
  in
  let batches = Streaming.Stream.to_list list_stream in
  let open Lwt_result.Syntax in
  let* _ =
    Repo.transaction (fun c ->
        lwt_result_fold_left batches ~f:(upsert_features c))
  in
  Lwt.return_ok ()
