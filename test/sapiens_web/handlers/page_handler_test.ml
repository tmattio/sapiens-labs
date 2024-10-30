open Lwt.Syntax
open Opium
open Opium_testing

let test_case n = Test_support.test_case_db n `Quick

let handle_request = handle_request Sapiens_web.app

let suite =
  [ ( "GET /"
    , [ test_case "renders the index page" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            check_status `OK res.status;
            check_body_contains
              "<title>Your machine learning platform · Sapiens</title>"
              res.body)
      ] )
  ; ( "GET /page_not_found"
    , [ test_case "renders the not found error page" (fun _switch () ->
            let req = Request.make "/page_not_found" `GET in
            let* res = handle_request req in
            check_status `Not_found res.status;
            check_body_contains "<title>Not Found · Sapiens</title>" res.body)
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - Page Handler" suite
