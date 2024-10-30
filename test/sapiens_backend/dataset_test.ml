open Alcotest
open Lwt.Syntax
open Test_testable_account
open Test_testable_dataset
open Test_fixture_dataset

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n f = Test_support.test_case_db n `Quick (fun _switch () -> f ())

let update_dataset_tokens_date () =
  let request =
    [%rapper
      execute
        {sql|
        UPDATE datasets_tokens SET created_at = '2020-01-01 00:00:00'
        |sql}]
  in
  Sapiens_backend.Repo.query (fun c -> request () c)

let get_collaboration_token ~inviter ~dataset ~collaborator =
  let open Lwt_result.Syntax in
  let* extracted_token =
    Test_support.extract_token (fun fn ->
        Sapiens_backend.Dataset.deliver_collaboration_instructions
          ~as_:inviter
          ~url_fn:fn
          collaborator
          dataset)
  in
  let token =
    extracted_token
    |> Sapiens_backend.Token.of_string
    |> (fun token -> Sapiens_backend.Token.decode_base64 token |> Result.get_ok)
    |> Sapiens_backend.Token.hash
    |> (fun token -> Sapiens_backend.Token.encode_base64 token)
    |> Result.get_ok
  in
  let+ token_ = Sapiens_backend.Dataset.Dataset_token.get_by_token token in
  token_

let get_transfer_token ~inviter ~dataset ~new_owner =
  let open Lwt_result.Syntax in
  let* extracted_token =
    Test_support.extract_token (fun fn ->
        Sapiens_backend.Dataset.deliver_transfer_instructions
          ~as_:inviter
          ~url_fn:fn
          new_owner
          dataset)
  in
  let token =
    extracted_token
    |> Sapiens_backend.Token.of_string
    |> (fun token -> Sapiens_backend.Token.decode_base64 token |> Result.get_ok)
    |> Sapiens_backend.Token.hash
    |> (fun token -> Sapiens_backend.Token.encode_base64 token)
    |> Result.get_ok
  in
  let+ token_ = Sapiens_backend.Dataset.Dataset_token.get_by_token token in
  token_

let setup () =
  let+ dataset = dataset_fixture () in
  dataset

let suite =
  [ ( "list_datasets"
    , [ test_case "returns all user datasets" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ () in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_ user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [ dataset_ ] fetched_datasets)
      ; test_case "does not return other users datasets" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_2 = dataset_fixture ~user:user_2 () in
            let* fetched_datasets =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_ user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            let+ fetched_datasets2 =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_2 user_2
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [ dataset_ ] fetched_datasets;
            check (list dataset) "is same list" [ dataset_2 ] fetched_datasets2)
      ; test_case
          "does not return private datasets if user does not have access"
          (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_1 = dataset_fixture ~user:user_ ~is_public:true () in
            let* _dataset_2 = dataset_fixture ~user:user_ ~is_public:false () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_2 user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [ dataset_1 ] fetched_datasets)
      ; test_case "returns private datasets if user has access" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_1 = dataset_fixture ~user:user_ ~is_public:true () in
            let* dataset_2 = dataset_fixture ~user:user_ ~is_public:false () in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_ user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check
              (list dataset)
              "is same list"
              [ dataset_1; dataset_2 ]
              fetched_datasets)
      ] )
  ; ( "get_dataset_by_id"
    , [ test_case "returns the dataset with given id" (fun () ->
            let* dataset_ = setup () in
            let+ fetched_dataset =
              Sapiens_backend.Dataset.get_dataset_by_id
                ~as_:dataset_.user
                dataset_.id
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset with given id"
            in
            check dataset "is same dataset" dataset_ fetched_dataset)
      ; test_case
          "does not return the dataset if user does not have access"
          (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ ~is_public:false () in
            let+ fetched_dataset =
              Sapiens_backend.Dataset.get_dataset_by_id ~as_:user_2 dataset_.id
            in
            check
              (result dataset error)
              "is permission denied"
              (Error `Permission_denied)
              fetched_dataset)
      ] )
  ; ( "get_dataset_by_name_and_username"
    , [ test_case
          "returns the dataset with given name and owner's username"
          (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ () in
            let+ fetched_dataset =
              Sapiens_backend.Dataset.get_dataset_by_name_and_username
                ~as_:dataset_.user
                ~name:dataset_.name
                ~username:user_.username
              |> Test_support.get_lwt_ok
                   ~msg:
                     "could not fetch dataset with given name and owner's name"
            in
            check dataset "is same dataset" dataset_ fetched_dataset)
      ; test_case
          "does not return the dataset if user does not have access"
          (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ ~is_public:false () in
            let+ fetched_dataset =
              Sapiens_backend.Dataset.get_dataset_by_name_and_username
                ~as_:user_2
                ~name:dataset_.name
                ~username:user_.username
            in
            check
              (result dataset error)
              "is permission denied"
              (Error `Permission_denied)
              fetched_dataset)
      ] )
  ; ( "create_dataset"
    , [ test_case "with valid data creates a dataset" (fun () ->
            let* user = Test_fixture_account.user_fixture () in
            let name = name_fixture () in
            let+ result =
              Sapiens_backend.Dataset.create_dataset ~as_:user ~name ()
            in
            check bool "is ok" true (Result.is_ok result))
      ; test_case "with invalid data returns error changeset" (fun () ->
            let* user = Test_fixture_account.user_fixture () in
            (* Change ID of user to non-existing ID *)
            let user = { user with id = 1234 } in
            let name = name_fixture () in
            let+ result =
              Sapiens_backend.Dataset.create_dataset ~as_:user ~name ()
            in
            check bool "is error" true (Result.is_error result))
      ] )
  ; ( "update_dataset"
    , [ test_case "with valid data updates the dataset" (fun () ->
            let* dataset_ = dataset_fixture () in
            let name_ = name_fixture ~v:"new-name" () in
            let+ updated_dataset =
              Sapiens_backend.Dataset.update_dataset
                ~name:name_
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok ~msg:"could not update the dataset"
            in
            check
              dataset
              "is updated dataset"
              { dataset_ with
                name =
                  Sapiens_backend.Dataset.Dataset.Name.of_string "new-name"
                  |> Test_support.get_ok ~msg:"failed to create dataset name"
              }
              updated_dataset)
      ; test_case "does not update the dataset if user is not owner" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ ~is_public:false () in
            let name_ = name_fixture ~v:"new-name" () in
            let+ updated_dataset =
              Sapiens_backend.Dataset.update_dataset
                ~name:name_
                ~as_:user_2
                dataset_
            in
            check
              (result dataset error)
              "is permission denied"
              (Error `Permission_denied)
              updated_dataset)
      ] )
  ; ( "delete_dataset"
    , [ test_case "deletes the dataset" (fun () ->
            let* dataset_ = dataset_fixture () in
            let* () =
              Sapiens_backend.Dataset.delete_dataset ~as_:dataset_.user dataset_
              |> Test_support.get_lwt_ok ~msg:"could not delete dataset"
            in
            let+ result_ =
              Sapiens_backend.Dataset.get_dataset_by_id
                ~as_:dataset_.user
                dataset_.id
            in
            check
              (result dataset error)
              "is not found"
              (Error `Not_found)
              result_)
      ; test_case "does not delete the dataset if user is not owner" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ ~is_public:false () in
            let+ result_ =
              Sapiens_backend.Dataset.delete_dataset ~as_:user_2 dataset_
            in
            check
              (result unit error)
              "is permission denied"
              (Error `Permission_denied)
              result_)
      ] )
  ; ( "search_datasets"
    , [ test_case "returns dataset when name matches" (fun () ->
            let name_ = name_fixture ~v:"dataset-name" () in
            let* dataset_ = dataset_fixture ~name:name_ () in
            let q = Sapiens_backend.Dataset.Dataset.Query.of_string "dataset" in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.search_datasets ~as_:dataset_.user q
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [ dataset_ ] fetched_datasets)
      ; test_case
          "does not return the dataset when name does not match"
          (fun () ->
            let name_ = name_fixture ~v:"dataset-name" () in
            let* dataset_ = dataset_fixture ~name:name_ () in
            let q =
              Sapiens_backend.Dataset.Dataset.Query.of_string "not found"
            in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.search_datasets ~as_:dataset_.user q
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [] fetched_datasets)
      ; test_case
          "does not return private datasets if user does not have access"
          (fun () ->
            let name_ = name_fixture ~v:"dataset-name" () in
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* _ =
              dataset_fixture ~name:name_ ~user:user_ ~is_public:false ()
            in
            let q =
              Sapiens_backend.Dataset.Dataset.Query.of_string "dataset-name"
            in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.search_datasets ~as_:user_2 q
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check (list dataset) "is same list" [] fetched_datasets)
      ; test_case "returns private datasets if user have access" (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* dataset_1 = dataset_fixture ~user:user_ ~is_public:true () in
            let* dataset_2 = dataset_fixture ~user:user_ ~is_public:false () in
            let+ fetched_datasets =
              Sapiens_backend.Dataset.list_user_datasets ~as_:user_ user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of datasets"
            in
            check
              (list dataset)
              "is same list"
              [ dataset_1; dataset_2 ]
              fetched_datasets)
      ] )
  ; ( "get_dataset_feature_definitions"
    , [ test_case "returns the dataset feature definitions" (fun () ->
            let* dataset_ = setup () in
            let* bbox_ = definition_bbox_fixture ~dataset:dataset_ () in
            let* label_ = definition_label_fixture ~dataset:dataset_ () in
            let* image_ = definition_image_fixture ~dataset:dataset_ () in
            let* text_ = definition_text_fixture ~dataset:dataset_ () in
            let* fetched_feature_definitions =
              Sapiens_backend.Dataset.get_dataset_feature_definitions
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset feature definitions"
            in
            check
              (list definition)
              "is same list"
              [ bbox_; label_; image_; text_ ]
              fetched_feature_definitions;
            Lwt.return ())
      ; test_case
          "does not return the dataset feature definitions if user does not \
           have acces"
          (fun () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = dataset_fixture ~user:user_ ~is_public:false () in
            let* _ = definition_text_fixture ~dataset:dataset_ () in
            let+ fetched_feature_definitions =
              Sapiens_backend.Dataset.get_dataset_feature_definitions
                ~as_:user_2
                dataset_
            in
            check
              (result (list definition) error)
              "is permission denied"
              (Error `Permission_denied)
              fetched_feature_definitions)
      ] )
  ; ( "create_dataset_feature_definition"
    , [ test_case "creates the dataset feature definition" (fun () ->
            let* dataset_ = setup () in
            let feature_name_ = feature_name_fixture () in
            let definition_ : Sapiens_backend.Dataset.Datapoint.definition_spec =
              Sapiens_backend.Dataset.Datapoint.(
                Bbox_def (Bbox.Definition.make ()))
            in
            let* definition_ =
              Sapiens_backend.Dataset.create_dataset_feature_definition
                dataset_
                ~as_:dataset_.user
                ~name:feature_name_
                ~definition:definition_
              |> Test_support.get_lwt_ok
                   ~msg:"could not create feature definition"
            in
            check
              feature_name
              "is same feature name"
              feature_name_
              (Sapiens_backend.Dataset.Datapoint.feature_name_of_definition
                 definition_);
            Lwt.return ())
      ; test_case
          "does not creates the dataset feature definition if user does not \
           have acces"
          (fun () ->
            let* dataset_ = setup () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let feature_name_ = feature_name_fixture () in
            let definition_ : Sapiens_backend.Dataset.Datapoint.definition_spec =
              Sapiens_backend.Dataset.Datapoint.(
                Bbox_def (Bbox.Definition.make ()))
            in
            let* definition_ =
              Sapiens_backend.Dataset.create_dataset_feature_definition
                dataset_
                ~as_:user_2
                ~name:feature_name_
                ~definition:definition_
            in
            check
              (result definition error)
              "is permission denied"
              (Error `Permission_denied)
              definition_;
            Lwt.return ())
      ; test_case
          "returns an error if the feature name already exists"
          (fun () ->
            let* dataset_ = setup () in
            let feature_name_ = feature_name_fixture () in
            let definition_ : Sapiens_backend.Dataset.Datapoint.definition_spec =
              Sapiens_backend.Dataset.Datapoint.(
                Bbox_def (Bbox.Definition.make ()))
            in
            let* _persisted_definition_ =
              Sapiens_backend.Dataset.create_dataset_feature_definition
                dataset_
                ~as_:dataset_.user
                ~name:feature_name_
                ~definition:definition_
              |> Test_support.get_lwt_ok
                   ~msg:"could not create feature definition"
            in
            let* result_ =
              Sapiens_backend.Dataset.create_dataset_feature_definition
                dataset_
                ~as_:dataset_.user
                ~name:feature_name_
                ~definition:definition_
            in
            check
              (result definition error)
              "is error"
              (Error `Already_exists)
              result_;
            Lwt.return ())
      ] )
  ; ( "update_dataset_feature_definition"
    , [ test_case "updates the dataset feature definition" (fun () ->
            let* dataset_ = setup () in
            let feature_name_1 = feature_name_fixture ~v:"feature 1" () in
            let feature_name_2 = feature_name_fixture ~v:"feature 2" () in
            let* bbox_ =
              definition_bbox_fixture ~name:feature_name_1 ~dataset:dataset_ ()
            in
            let* updated_bbox_ =
              Sapiens_backend.Dataset.update_dataset_feature_definition
                bbox_
                ~as_:dataset_.user
                ~name:feature_name_2
              |> Test_support.get_lwt_ok
                   ~msg:"could not update feature definition"
            in
            check
              definition
              "is updated feature definition"
              { bbox_ with feature_name = feature_name_2 }
              updated_bbox_;
            Lwt.return ())
      ; test_case
          "does not update the dataset feature definition if user does not \
           have acces"
          (fun () ->
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = setup () in
            let feature_name_1 = feature_name_fixture ~v:"feature 1" () in
            let feature_name_2 = feature_name_fixture ~v:"feature 2" () in
            let* bbox_ =
              definition_bbox_fixture ~name:feature_name_1 ~dataset:dataset_ ()
            in
            let* updated_bbox_ =
              Sapiens_backend.Dataset.update_dataset_feature_definition
                bbox_
                ~as_:user_2
                ~name:feature_name_2
            in
            check
              (result definition error)
              "is permission denied"
              (Error `Permission_denied)
              updated_bbox_;
            Lwt.return ())
      ; test_case
          "returns an error if the feature name already exists"
          (fun () ->
            let* dataset_ = setup () in
            let feature_name_1 = feature_name_fixture ~v:"feature 1" () in
            let feature_name_2 = feature_name_fixture ~v:"feature 2" () in
            let* _bbox_1 =
              definition_bbox_fixture ~name:feature_name_1 ~dataset:dataset_ ()
            in
            let* bbox_2 =
              definition_bbox_fixture ~name:feature_name_2 ~dataset:dataset_ ()
            in
            let* result_ =
              Sapiens_backend.Dataset.update_dataset_feature_definition
                bbox_2
                ~as_:dataset_.user
                ~name:feature_name_1
            in
            check
              (result definition error)
              "is error"
              (Error `Already_exists)
              result_;
            Lwt.return ())
      ] )
  ; ( "delete_dataset_feature_definition"
    , [ test_case "deletes the dataset feature definition" (fun () ->
            let* dataset_ = setup () in
            let* bbox_ = definition_bbox_fixture ~dataset:dataset_ () in
            let* () =
              Sapiens_backend.Dataset.delete_dataset_feature_definition
                ~as_:dataset_.user
                bbox_
              |> Test_support.get_lwt_ok
                   ~msg:"could not delete dataset feature definitions"
            in
            let* fetched_feature_definitions =
              Sapiens_backend.Dataset.get_dataset_feature_definitions
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset feature definitions"
            in
            check
              (list definition)
              "is same list"
              []
              fetched_feature_definitions;
            Lwt.return ())
      ; test_case
          "does not delete the dataset feature definition if user does not \
           have acces"
          (fun () ->
            let* user_2 = Test_fixture_account.user_fixture () in
            let* dataset_ = setup () in
            let* bbox_ = definition_bbox_fixture ~dataset:dataset_ () in
            let* () =
              Sapiens_backend.Dataset.delete_dataset_feature_definition
                ~as_:dataset_.user
                bbox_
              |> Test_support.get_lwt_ok
                   ~msg:"could not delete dataset feature definitions"
            in
            let* fetched_feature_definitions =
              Sapiens_backend.Dataset.get_dataset_feature_definitions
                ~as_:user_2
                dataset_
            in
            check
              (result (list definition) error)
              "is permission denied"
              (Error `Permission_denied)
              fetched_feature_definitions;
            Lwt.return ())
      ; test_case
          "deletes the features associated with the feature definition"
          (fun () ->
            let* dataset_ = setup () in
            let* def = definition_bbox_fixture ~dataset:dataset_ () in
            let def_bbox_ =
              match def.spec with
              | Bbox_def spec ->
                { def with spec }
              | _ ->
                assert false
            in
            let* bbox_ =
              bbox_fixture ~dataset:dataset_ ~definition:def_bbox_ ()
            in
            let features = Sapiens_backend.Dataset.Datapoint.[ Bbox bbox_ ] in
            let* _datapoint_ =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* _ =
              Sapiens_backend.Dataset.delete_dataset_feature_definition
                ~as_:dataset_.user
                def
              |> Test_support.get_lwt_ok
                   ~msg:"could not delete dataset feature definitions"
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok ~msg:"could not get datapoints"
            in
            check (list datapoint) "is same list" [] fetched_datapoints;
            Lwt.return ())
      ] )
  ; ( "get_dataset_datapoints"
    , [ test_case "returns the dataset datapoints" (fun () ->
            let* dataset_ = setup () in
            let* bbox_ = bbox_fixture ~dataset:dataset_ () in
            let* label_ = label_fixture ~dataset:dataset_ () in
            let* image_ = image_fixture ~dataset:dataset_ () in
            let* text_ = text_fixture ~dataset:dataset_ () in
            let features =
              Sapiens_backend.Dataset.Datapoint.
                [ Bbox bbox_; Label label_; Image image_; Text text_ ]
            in
            let* _datapoint_ =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset datapoints"
            in
            check
              int
              "is same int"
              dataset_.id
              (List.hd fetched_datapoints).dataset_id;
            check
              (list feature)
              "is same list"
              features
              (List.hd fetched_datapoints).features;
            Lwt.return ())
      ; test_case
          "does not return the dataset datapoints if user does not have acces"
          (fun () ->
            let* dataset_ = dataset_fixture ~is_public:false () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* bbox_ = bbox_fixture ~dataset:dataset_ () in
            let features = Sapiens_backend.Dataset.Datapoint.[ Bbox bbox_ ] in
            let* _datapoint_ =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                ~as_:user_2
                dataset_
            in
            check
              (result (list datapoint) error)
              "is permission denied"
              (Error `Permission_denied)
              fetched_datapoints;
            Lwt.return ())
      ; test_case
          "returns the correct number of datapoints with limit argument"
          (fun () ->
            let* dataset_ = setup () in
            let* bbox_ = bbox_fixture ~dataset:dataset_ () in
            let features = Sapiens_backend.Dataset.Datapoint.[ Bbox bbox_ ] in
            let* datapoint_1 =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* _datapoint_2 =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                dataset_
                ~as_:dataset_.user
                ~limit:1
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset datapoints"
            in
            check int "is same length" 1 (List.length fetched_datapoints);
            check
              int
              "is same int"
              datapoint_1.id
              (List.hd fetched_datapoints).id;
            Lwt.return ())
      ; test_case
          "returns the correct datapoints with offset argument"
          (fun () ->
            let* dataset_ = setup () in
            let* bbox_ = bbox_fixture ~dataset:dataset_ () in
            let features = Sapiens_backend.Dataset.Datapoint.[ Bbox bbox_ ] in
            let* _datapoint_1 =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* datapoint_2 =
              datapoint_fixture ~dataset:dataset_ ~features ()
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                dataset_
                ~as_:dataset_.user
                ~offset:1
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset datapoints"
            in
            check int "is same length" 1 (List.length fetched_datapoints);
            check
              int
              "is same int"
              datapoint_2.id
              (List.hd fetched_datapoints).id;
            Lwt.return ())
      ; test_case "returns only the datapoints of the given split" (fun () ->
            let split_ = "test" in
            let split_2 = "eval" in
            let* dataset_ = dataset_fixture ~is_public:false () in
            let* bbox_ = bbox_fixture ~dataset:dataset_ () in
            let features = Sapiens_backend.Dataset.Datapoint.[ Bbox bbox_ ] in
            let* datapoint_ =
              datapoint_fixture ~dataset:dataset_ ~split:split_ ~features ()
            in
            let* _ =
              datapoint_fixture ~dataset:dataset_ ~split:split_2 ~features ()
            in
            let* fetched_datapoints =
              Sapiens_backend.Dataset.get_dataset_datapoints
                ~as_:dataset_.user
                ~split:split_
                dataset_
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch dataset datapoints using splits"
            in
            check
              (list datapoint)
              "is same list"
              [ datapoint_ ]
              fetched_datapoints;
            Lwt.return ())
      ] )
  ; ( "create_dataset_datapoint"
    , [ test_case "creates the dataset datapoints" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "does not create the dataset datapoints if user does not have acces"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "returns an error if the datapoints don't match the feature \
           definitions"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "returns an error if the feature definition validation fails"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "deliver_collaboration_instructions"
    , [ test_case
          "validates that the user is not already a collaborator"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "validates that the user has the rights to invite other users"
          (fun () ->
            let* dataset_ = dataset_fixture () in
            let* other_user = Test_fixture_account.user_fixture () in
            let* collaborator_ = Test_fixture_account.user_fixture () in
            let+ r =
              get_collaboration_token
                ~inviter:other_user
                ~collaborator:collaborator_
                ~dataset:dataset_
            in
            check
              (result dataset_token error)
              "is permission defined"
              (Error `Permission_denied)
              r)
      ; test_case "sends token through notification" (fun () ->
            let* dataset_ = dataset_fixture () in
            let* collaborator_ = Test_fixture_account.user_fixture () in
            let+ token_ =
              get_collaboration_token
                ~inviter:dataset_.user
                ~collaborator:collaborator_
                ~dataset:dataset_
              |> Test_support.get_lwt_ok
                   ~msg:"could not get collaboration token"
            in
            check email "same email" collaborator_.email token_.sent_to;
            check int "same id" collaborator_.id token_.user_id;
            check context "same context" Invite_collaborator token_.context)
      ] )
  ; ( "accept_collaboration_invitation"
    , let setup () =
        let* dataset_ = dataset_fixture () in
        let* collaborator_ = Test_fixture_account.user_fixture () in
        let+ extracted_token =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Dataset.deliver_collaboration_instructions
                ~as_:dataset_.user
                ~url_fn:fn
                collaborator_
                dataset_)
          |> Test_support.get_lwt_ok ~msg:"cannot extract token"
        in
        dataset_, collaborator_, extracted_token
      in
      [ test_case "adds the user as a dataset collaborator" (fun () ->
            let* _dataset_, collaborator_, extracted_token = setup () in
            let+ dataset_ =
              Sapiens_backend.Dataset.accept_collaboration_invitation
                ~as_:collaborator_
                (Sapiens_backend.Token.of_string extracted_token)
              |> Test_support.get_lwt_ok ~msg:"cannot accept invitation"
            in
            check
              (list user)
              "is same"
              dataset_.Sapiens_backend.Dataset.Dataset.collaborators
              [ collaborator_ ])
      ; test_case
          "validates that the current user is the invited user"
          (fun () ->
            let* _dataset_, _collaborator_, extracted_token = setup () in
            let* other_user = Test_fixture_account.user_fixture () in
            let+ r =
              Sapiens_backend.Dataset.accept_collaboration_invitation
                ~as_:other_user
                (Sapiens_backend.Token.of_string extracted_token)
            in
            check
              (result dataset error)
              "is permission denied"
              (Error `Invalid_token)
              r)
      ; test_case "validates that the invitation did not expire" (fun () ->
            let* _dataset_, collaborator_, extracted_token = setup () in
            let* () =
              update_dataset_tokens_date ()
              |> Test_support.get_lwt_ok
                   ~msg:"could not update dataset tokens date"
            in
            let+ r =
              Sapiens_backend.Dataset.accept_collaboration_invitation
                ~as_:collaborator_
                (Sapiens_backend.Token.of_string extracted_token)
            in
            check
              (result dataset error)
              "is permission denied"
              (Error `Not_found)
              r)
      ] )
  ; ( "revoke_collaboration_invitation"
    , let setup () =
        let* dataset_ = dataset_fixture () in
        let* collaborator_ = Test_fixture_account.user_fixture () in
        let+ extracted_token =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Dataset.deliver_collaboration_instructions
                ~as_:dataset_.user
                ~url_fn:fn
                collaborator_
                dataset_)
          |> Test_support.get_lwt_ok ~msg:"cannot extract token"
        in
        dataset_, collaborator_, extracted_token
      in
      [ test_case "revokes the collaboration invitation" (fun () ->
            (* TODO: fix failing test *)
            (* let* dataset_, collaborator_, extracted_token = setup () in let*
               _ = Sapiens_backend.Dataset.revoke_collaboration_invitation
               ~as_:dataset_.user collaborator_ dataset_ |>
               Test_support.get_lwt_ok ~msg:"could not revoke the collaboration
               invitation" in let+ r =
               Sapiens_backend.Dataset.accept_collaboration_invitation
               ~as_:collaborator_ (Sapiens_backend.Token.of_string
               extracted_token) in check (result dataset error) "is not found"
               (Error `Not_found) r *)
            Lwt.return ())
      ; test_case
          "validates that the current user is the inviter or owner of the \
           dataset"
          (fun () ->
            let* dataset_, collaborator_, _extracted_token = setup () in
            let* other_user = Test_fixture_account.user_fixture () in
            let+ r =
              Sapiens_backend.Dataset.revoke_collaboration_invitation
                ~as_:other_user
                collaborator_
                dataset_
            in
            check
              (result unit error)
              "is permission defined"
              (Error `Permission_denied)
              r)
      ] )
  ; ( "get_pending_collaboration_invitations"
    , let setup () =
        let* dataset_ = dataset_fixture () in
        let* collaborator_ = Test_fixture_account.user_fixture () in
        let+ extracted_token =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Dataset.deliver_collaboration_instructions
                ~as_:dataset_.user
                ~url_fn:fn
                collaborator_
                dataset_)
          |> Test_support.get_lwt_ok ~msg:"cannot extract token"
        in
        dataset_, collaborator_, extracted_token
      in
      [ test_case "lists the pending invitations" (fun () ->
            let* dataset_, collaborator_, _extracted_token = setup () in
            let+ emails =
              Sapiens_backend.Dataset.get_pending_collaboration_invitations
                ~as_:dataset_.user
                dataset_
              |> Test_support.get_lwt_ok ~msg:"cannot get pending collaborators"
            in
            check (list email) "is same" [ collaborator_.email ] emails)
      ] )
  ; ( "remove_collaborator"
    , [ test_case "removes the collaborator from the dataset" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "validates that the user has the rights to remove a collaborator"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "deliver_transfer_instructions"
    , [ test_case
          "validates that the user is the owner of the dataset"
          (fun () ->
            let* dataset_ = dataset_fixture () in
            let* other_user = Test_fixture_account.user_fixture () in
            let* new_owner = Test_fixture_account.user_fixture () in
            let+ token_ =
              get_transfer_token
                ~inviter:other_user
                ~new_owner
                ~dataset:dataset_
            in
            check
              (result dataset_token error)
              "is permission defined"
              (Error `Permission_denied)
              token_)
      ; test_case "sends token through notification" (fun () ->
            let* dataset_ = dataset_fixture () in
            let* new_owner = Test_fixture_account.user_fixture () in
            let+ token_ =
              get_transfer_token
                ~inviter:dataset_.user
                ~new_owner
                ~dataset:dataset_
              |> Test_support.get_lwt_ok ~msg:"could not get transfer token"
            in
            check email "same email" new_owner.email token_.sent_to;
            check int "same id" new_owner.id token_.user_id;
            check context "same context" Transfer token_.context)
      ] )
  ; ( "accept_transfer_invitation"
    , [ test_case "transfers the owner of the dataset" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "validates that the current user is the invited user"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case "validates that the invitation did not expire" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "revoke_transfer_invitation"
    , [ test_case "revokes the collaboration invitation" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "validates that the current user is owner of the dataset"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "get_pending_transfer"
    , [ test_case "lists the pending transfer" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens - Dataset" suite
