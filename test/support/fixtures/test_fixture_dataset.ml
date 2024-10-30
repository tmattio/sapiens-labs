open Sapiens_backend

module type S

let make_fixture ~ctor ~default_fn =
  let count = ref 0 in
  let count_mutex = Mutex.create () in
  fun ?v () ->
    Mutex.lock count_mutex;
    let v =
      ctor (Option.value v ~default:(default_fn (string_of_int !count)))
      |> Result.get_ok
    in
    count := !count + 1;
    Mutex.unlock count_mutex;
    v

let name_fixture =
  make_fixture ~ctor:Dataset.Dataset.Name.of_string ~default_fn:(fun id ->
      "dataset-name-" ^ id)

let dataset_fixture ?user ?name ?is_public () =
  let open Lwt.Syntax in
  let* user =
    match user with
    | Some user ->
      Lwt.return user
    | None ->
      Test_fixture_account.user_fixture ()
  in
  let name = Option.value name ~default:(name_fixture ()) in
  let+ d = Dataset.create_dataset ~as_:user ~name ?is_public () in
  Result.get_ok d

let feature_name_fixture =
  make_fixture
    ~ctor:Dataset.Datapoint.Feature_name.of_string
    ~default_fn:(fun id -> "feature-name-" ^ id)

let make_definition ?dataset ?name ~definition () =
  let open Lwt.Syntax in
  let* dataset =
    match dataset with
    | Some dataset ->
      Lwt.return dataset
    | None ->
      dataset_fixture ()
  in
  let name = Option.value name ~default:(feature_name_fixture ()) in
  let+ r =
    Dataset.create_dataset_feature_definition
      dataset
      ~as_:dataset.user
      ~name
      ~definition
  in
  Result.get_ok r

let definition_bbox_fixture ?dataset ?name () =
  let definition : Dataset.Datapoint.definition_spec =
    Dataset.Datapoint.(Bbox_def (Bbox.Definition.make ()))
  in
  make_definition ?dataset ?name ~definition ()

let definition_label_fixture ?dataset ?name ?classes () =
  let classes =
    Option.value classes ~default:[ "class 1"; "class 2"; "class 3" ]
  in
  let definition : Dataset.Datapoint.definition_spec =
    Dataset.Datapoint.(Label_def (Label.Definition.make ~classes))
  in
  make_definition ?dataset ?name ~definition ()

let definition_image_fixture ?dataset ?name ?height ?width ?channels () =
  let definition : Dataset.Datapoint.definition_spec =
    Dataset.Datapoint.(
      Image_def (Image.Definition.make ?height ?width ?channels ()))
  in
  make_definition ?dataset ?name ~definition ()

let definition_text_fixture ?dataset ?name () =
  let definition : Dataset.Datapoint.definition_spec =
    Dataset.Datapoint.(Text_def (Text.Definition.make ()))
  in
  make_definition ?dataset ?name ~definition ()

let bbox_fixture ?definition ?dataset ?y_min ?x_min ?y_max ?x_max () =
  let open Lwt.Syntax in
  let+ definition =
    match definition with
    | Some definition ->
      Lwt.return definition
    | None ->
      let+ definition = definition_bbox_fixture ?dataset () in
      (match definition.spec with
      | Bbox_def spec ->
        { definition with spec }
      | _ ->
        Alcotest.fail "The feature definition fixture is not a bbox")
  in
  let y_min = Option.value y_min ~default:0. in
  let x_min = Option.value x_min ~default:0. in
  let y_max = Option.value y_max ~default:0. in
  let x_max = Option.value x_max ~default:0. in
  Dataset.Datapoint.Bbox.make ~definition ~y_min ~x_min ~y_max ~x_max
  |> Test_support.get_ok ~msg:"failed to create datapoint"

let label_fixture ?definition ?dataset ?name () =
  let open Lwt.Syntax in
  let+ definition =
    match definition with
    | Some definition ->
      Lwt.return definition
    | None ->
      let+ definition = definition_label_fixture ?dataset () in
      (match definition.spec with
      | Label_def spec ->
        { definition with spec }
      | _ ->
        Alcotest.fail "The feature definition fixture is not a class label")
  in
  let label = Option.value name ~default:"class 1" in
  Dataset.Datapoint.Label.make ~definition label
  |> Test_support.get_ok ~msg:"failed to create datapoint"

let image_fixture ?definition ?dataset ?url ?height ?width ?channels () =
  let open Lwt.Syntax in
  let+ definition =
    match definition with
    | Some definition ->
      Lwt.return definition
    | None ->
      let+ definition = definition_image_fixture ?dataset () in
      (match definition.spec with
      | Image_def spec ->
        { definition with spec }
      | _ ->
        Alcotest.fail "The feature definition fixture is not a image")
  in
  let url =
    Option.value
      url
      ~default:
        "https://upload.wikimedia.org/wikipedia/en/7/7d/Lenna_%28test_image%29.png"
  in
  let height = Option.value height ~default:512 in
  let width = Option.value width ~default:512 in
  let channels = Option.value channels ~default:3 in
  Dataset.Datapoint.Image.make ~definition ~url ~height ~width ~channels
  |> Test_support.get_ok ~msg:"failed to create datapoint"

let text_fixture ?definition ?dataset ?value () =
  let open Lwt.Syntax in
  let+ definition =
    match definition with
    | Some definition ->
      Lwt.return definition
    | None ->
      let+ definition = definition_text_fixture ?dataset () in
      (match definition.spec with
      | Text_def spec ->
        { definition with spec }
      | _ ->
        Alcotest.fail "The feature definition fixture is not a text")
  in
  let value =
    Option.value value ~default:"The quick brown fox jumps over the lazy dog"
  in
  Dataset.Datapoint.Text.make ~definition value
  |> Test_support.get_ok ~msg:"failed to create datapoint"

let datapoint_fixture ?dataset ?features ?split () =
  let open Lwt.Syntax in
  let* dataset =
    match dataset with
    | Some dataset ->
      Lwt.return dataset
    | None ->
      dataset_fixture ()
  in
  let features = Option.value features ~default:[] in
  let split_ = Option.value split ~default:"" in
  let+ r =
    Dataset.create_dataset_datapoint
      ~features
      ~split:split_
      ~as_:dataset.user
      dataset
  in
  Result.get_ok r
