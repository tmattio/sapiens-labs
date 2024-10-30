open Alcotest
open Lwt.Syntax
open Opium
open Opium_testing
open Test_testable_account
open Test_fixture_account

let test_case n = Test_support.test_case_db n `Quick

let handle_request = handle_request (Sapiens_web.app ())

let suite =
  [ ( "GET /users/confirm"
    , [ test_case "renders the confirmation page" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            let+ body = res.body |> Body.to_string in
            check_status `OK res.status;
            check
              bool
              "contains title"
              true
              (String.contains_s ~sub:"<title>Sapiens</title>" body))
      ] )
  ; ( "POST /users/confirm"
    , [ test_case "sends a new confirmation token" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not send confirmation token if account is confirmed"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not send confirmation token if email is invalid"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "GET /users/confirm/:token"
    , [ test_case "confirms the given token once" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not confirm email with invalid token" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run
  @@ Alcotest_lwt.run "sapiens-web - User Confirmation Handler" suite
