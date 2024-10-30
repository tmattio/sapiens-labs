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
  [ ( "GET /users/settings"
    , [ test_case "renders settings page" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            let+ body = res.body |> Body.to_string in
            check_status `OK res.status;
            check
              bool
              "contains title"
              true
              (String.contains_s ~sub:"<title>Sapiens</title>" body))
      ; test_case "redirects if user is not logged in" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "PUT /users/settings/update_password"
    , [ test_case
          "updates the user password and resets tokens"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not update password on invalid data" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "PUT /users/settings/update_email"
    , [ test_case "updates the user email" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not update email on invalid data" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "GET /users/settings/confirm_email/:token"
    , [ test_case "updates the user email once" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not update email with invalid token" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "redirects if user is not logged in" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - User Settings Handler" suite
