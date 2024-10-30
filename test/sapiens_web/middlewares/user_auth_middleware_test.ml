open Alcotest
open Lwt.Syntax
open Opium
open Sapiens_web
open Opium_testing

let test_case n = Alcotest_lwt.test_case n `Quick

let handle_request = handle_request (Sapiens_web.app ())

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let suite =
  [ ( "fetch_current_user"
    , [ test_case "authenticates user from session" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "authenticates user from cookies" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "does not authenticate if data is missing" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "redirect_if_user_is_authenticated"
    , [ test_case "redirects if user is authenticated" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not redirect if user is not authenticated"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ; ( "require_authenticated_user"
    , [ test_case "redirects if user is not authenticated" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case "stores the path to redirect to on GET" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ; test_case
          "does not redirect if user is not authenticated"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - User Auth Middleware" suite
