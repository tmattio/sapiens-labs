open Alcotest
open Lwt.Syntax
open Opium
open Opium_testing

let test_case n = Test_support.test_case_db_quick n

let handle_request = handle_request (Sapiens_web.app ())

let suite =
  [ ( "GET /datasets"
    , [ test_case "lists all datasets" (fun _switch () ->
            let req = Request.make "/datasets" `GET in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ; ( "GET /datasets/new"
    , [ test_case "renders creation form" (fun _switch () ->
            let req = Request.make "/datasets/new" `GET in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ; ( "POST /datasets"
    , [ test_case "redirects to show when data is valid" (fun _switch () ->
            let req = Request.make "/datasets" `POST in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ; test_case "renders errors when data is invalid" (fun _switch () ->
            let req = Request.make "/datasets" `POST in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ; ( "GET /datasets/:id/edit"
    , [ test_case "renders form for editing chosen dataset" (fun _switch () ->
            let req = Request.make "/datasets/:id/edit" `GET in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ; ( "PUT /datasets/:id"
    , [ test_case "redirects when data is valid" (fun _switch () ->
            let req = Request.make "/datasets/:id" `PUT in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ; test_case "renders errors when data is invalid" (fun _switch () ->
            let req = Request.make "/datasets/:id" `PUT in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ; ( "DELETE /datasets/:id"
    , [ test_case "deletes chosen dataset" (fun _switch () ->
            let req = Request.make "/datasets/:id" `DELETE in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains "<title>Datasets · Sapiens</title>" res.body)
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - Dataset Handler" suite
