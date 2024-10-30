open Alcotest
open Lwt.Syntax
open Test_testable_model
open Test_fixture_model

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n = Test_support.test_case_db n `Quick

let check_model = Alcotest.check (Alcotest.result model error)

let setup () =
  let+ model = model_fixture () in
  model

let suite =
  [ ( "list_models"
    , [ test_case "returns all user models" (fun _switch () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* model_ = model_fixture ~user:user_ () in
            let+ fetched_models =
              Sapiens_backend.Model.list_user_models user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of models"
            in
            check (list model) "is same list" [ model_ ] fetched_models)
      ; test_case "does not return other users models" (fun _switch () ->
            let* user_ = Test_fixture_account.user_fixture () in
            let* model_ = model_fixture ~user:user_ () in
            let* user_2 = Test_fixture_account.user_fixture () in
            let* model_2 = model_fixture ~user:user_2 () in
            let* fetched_models =
              Sapiens_backend.Model.list_user_models user_
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of models"
            in
            let+ fetched_models2 =
              Sapiens_backend.Model.list_user_models user_2
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of models"
            in
            check (list model) "is same list" [ model_ ] fetched_models;
            check (list model) "is same list" [ model_2 ] fetched_models2)
      ] )
  ; ( "get_model_by_id"
    , [ test_case "returns the model with given id" (fun _switch () ->
            let* model_ = setup () in
            let+ fetched_model =
              Sapiens_backend.Model.get_model_by_id model_.id
              |> Test_support.get_lwt_ok
                   ~msg:"could not fetch model with given id"
            in
            check model "is same model" model_ fetched_model)
      ] )
  ; ( "create_model"
    , [ test_case "with valid data creates a model" (fun _switch () ->
            let* user = Test_fixture_account.user_fixture () in
            let name = name_fixture () in
            let+ result = Sapiens_backend.Model.create_model ~user ~name () in
            check bool "is ok" true (Result.is_ok result))
      ; test_case "with invalid data returns error changeset" (fun _switch () ->
            let* user = Test_fixture_account.user_fixture () in
            (* Change ID of user to non-existing ID *)
            let user = { user with id = 1234 } in
            let name = name_fixture () in
            let+ result = Sapiens_backend.Model.create_model ~user ~name () in
            check bool "is error" true (Result.is_error result))
      ] )
  ; ( "update_model"
    , [ test_case "with valid data updates the model" (fun _switch () ->
            let* model_ = model_fixture () in
            let name_ = name_fixture ~v:"new-name" () in
            let+ updated_model =
              Sapiens_backend.Model.update_model ~name:name_ model_
              |> Test_support.get_lwt_ok ~msg:"could not update the model"
            in
            check
              model
              "is updated model"
              { model_ with
                name =
                  Sapiens_backend.Model.Model.Name.of_string "new-name"
                  |> Test_support.get_ok ~msg:"failed to create model name"
              }
              updated_model)
      ] )
  ; ( "delete_model"
    , [ test_case "deletes the model" (fun _switch () ->
            let* model_ = model_fixture () in
            let* () =
              Sapiens_backend.Model.delete_model model_
              |> Test_support.get_lwt_ok ~msg:"could not delete model"
            in
            let+ result_ = Sapiens_backend.Model.get_model_by_id model_.id in
            check (result model error) "is not found" (Error `Not_found) result_)
      ] )
  ; ( "search_models"
    , [ test_case "returns model when name matches" (fun _switch () ->
            let name_ = name_fixture ~v:"model-name" () in
            let* model_ = model_fixture ~name:name_ () in
            let q = Sapiens_backend.Model.Model.Query.of_string "model" in
            let+ fetched_models =
              Sapiens_backend.Model.search_models q
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of models"
            in
            check (list model) "is same list" [ model_ ] fetched_models)
      ; test_case
          "does not return the model when name does not match"
          (fun _switch () ->
            let name_ = name_fixture ~v:"model-name" () in
            let* model_ = model_fixture ~name:name_ () in
            let q = Sapiens_backend.Model.Model.Query.of_string "not found" in
            let+ fetched_models =
              Sapiens_backend.Model.search_models q
              |> Test_support.get_lwt_ok ~msg:"could not fetch list of models"
            in
            check (list model) "is same list" [] fetched_models)
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens - Model" suite
