open Alcotest
open Lwt.Syntax
open Opium
open Sapiens_web
open Opium_testing
open Test_testable_account
open Test_fixture_account

let test_case n = Alcotest_lwt.test_case n `Quick

let handle_request = handle_request (Sapiens_web.app ())

let suite =
  [ ( "GET /users/reset_password"
    , [ test_case "renders the reset password page" (fun _switch () ->
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
  ; ( "POST /users/reset_password"
    , [ test_case "sends a new reset password token" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not send reset password token if email is invalid"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "GET /users/reset_password :token"
    , [ test_case "renders reset password" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            let+ body = res.body |> Body.to_string in
            check_status `OK res.status;
            check
              bool
              "contains title"
              true
              (String.contains_s ~sub:"<title>Sapiens</title>" body))
      ; test_case
          "does not render reset password with invalid token"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "PUT /users/reset_password/:token"
    , [ test_case "resets password once" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not reset password on invalid data" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not reset password with invalid token"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run
  @@ Alcotest_lwt.run "sapiens-web - User Reset_password Handler" suite
