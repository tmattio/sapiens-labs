open Alcotest
open Lwt.Syntax
open Opium
open Sapiens_web
open Opium_testing
open Test_testable_account
open Test_fixture_account

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n = Test_support.test_case_db n `Quick

let handle_request = handle_request (Sapiens_web.app ())

let suite =
  [ ( "GET /users/register"
    , [ test_case "renders registration page" (fun _switch () ->
            let req = Request.make "/users/register" `GET in
            let* res = handle_request req in
            let+ body = res.body |> Body.to_string in
            check_status `OK res.status;
            check
              bool
              "contains title"
              true
              (String.contains_s
                 ~sub:"<title>Create an account · Sapiens</title>"
                 body))
      ; test_case "redirects if already logged in" (fun _switch () ->
            let req = Request.make "/users/register" `POST in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "POST /users/register"
    , [ test_case "creates account and logs the user in" (fun _switch () ->
            let email =
              email_fixture () |> Sapiens_backend.Account.User.Email.to_string
            in
            let username =
              username_fixture ()
              |> Sapiens_backend.Account.User.Username.to_string
            in
            let password = "strongpassword" in
            let req =
              Request.of_urlencoded
                "/users/register"
                `POST
                ~body:
                  [ "email", [ email ]
                  ; "username", [ username ]
                  ; "password", [ password ]
                  ]
            in
            let+ res = handle_request req in
            check_status `Found res.status)
      ; test_case "render errors for invalid data" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run
  @@ Alcotest_lwt.run "sapiens-web - User Registration Handler" suite
