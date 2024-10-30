open Alcotest
open Lwt.Syntax
open Opium
open Opium_testing
open Test_testable_account
open Test_fixture_account

let test_case n = Alcotest_lwt.test_case n `Quick

let handle_request = handle_request (Sapiens_web.app ())

let suite =
  [ ( "GET /users/login"
    , [ test_case "renders login page" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            let+ body = res.body |> Body.to_string in
            check_status `OK res.status;
            check
              bool
              "contains title"
              true
              (String.contains_s ~sub:"<title>Sapiens</title>" body))
      ; test_case "redirects if already logged in" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "POST /users/login"
    , [ test_case "logs the user in" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "logs the user in with remember me" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "emits error message with invalid credentials"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "DELETE /users/logout"
    , [ test_case "redirects if not logged in" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "logs the user out" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - User Session Handler" suite
