open Alcotest
open Lwt.Syntax
open Opium
open Sapiens_web
open Opium_testing
open Test_fixture_account

let test_case n = Test_support.test_case_db n `Quick

let handle_request = handle_request Sapiens_web.app

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let suite =
  [ ( "login_user"
    , let setup () =
        let+ user_ = user_fixture () in
        user_
      in
      [ test_case "stores the user token in the session" (fun _switch () ->
            let* user_ = setup () in
            let req = Request.make "/" `GET in
            let* res = Handler.User_auth.login_user user_ req in
            check_status `Found res.status;
            let { Cookie.value = _key, value; _ } =
              Response.cookie
                ~signed_with:Cookies.User_token.signer
                Cookies.User_token.key
                res
              |> Option.get
            in
            let+ fetched_user =
              value
              |> Sapiens_backend.Token.of_string
              |> Sapiens_backend.Account.get_user_by_session_token
              |> Test_support.get_lwt_ok
                   ~msg:"Could not fetch the user from the session token"
            in
            check int "same id" user_.id fetched_user.id)
      ; test_case "redirects to the configured path" (fun _switch () ->
            let* user_ = setup () in
            let cookie =
              [ Cookies.Return_to.make "/" ] |> Cookie.to_cookie_header
            in
            let req = Request.make "/hello" `GET |> Request.add_header cookie in
            let* _res = Handler.User_auth.login_user user_ req in
            Lwt.return ())
      ; test_case
          "writes a cookie if remember_me is configured"
          (fun _switch () ->
            let req = Request.make "/" `GET in
            let* _res = handle_request req in
            Lwt.return ())
      ; test_case
          "clears everything previously stored in the session"
          (fun _switch () ->
            (* TODO: We should clear other session values, only user session is
               cleared at the moment. *)
            Lwt.return ())
      ] )
  ; ( "logout_user"
    , [ test_case "erases session and cookies" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* _res = handle_request req in
            Lwt.return ())
      ; test_case "works even if user is already logged out" (fun _switch () ->
            let req = Request.make "/" `GET in
            let* _res = handle_request req in
            Lwt.return ())
      ] )
  ]

let () =
  Lwt_main.run @@ Alcotest_lwt.run "sapiens-web - User Auth Handler" suite
