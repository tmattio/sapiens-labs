open Alcotest
open Lwt.Syntax
open Test_testable_account
open Test_fixture_account

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n = Test_support.test_case_db n `Quick

let check_user = check (result user error)

let update_user_tokens_date () =
  let request =
    [%rapper
      execute
        {sql|
        UPDATE users_tokens SET created_at = '2020-01-01 00:00:00'
        |sql}]
  in
  Sapiens_backend.Repo.query (fun c -> request () c)

let suite =
  [ ( "get_user_by_email"
    , [ test_case
          "does not return the user if the email does not exist"
          (fun _switch () ->
            let email = email_fixture () in
            let+ r = Sapiens_backend.Account.get_user_by_email email in
            check_user "is not found" (Error `Not_found) r)
      ; test_case "returns the user if the email exists" (fun _switch () ->
            let* user_ = user_fixture () in
            let+ r = Sapiens_backend.Account.get_user_by_email user_.email in
            check_user "is a user" (Ok user_) r)
      ] )
  ; ( "get_user_by_email_and_password"
    , [ test_case
          "does not return the user if the email does not exist"
          (fun _switch () ->
            let email = email_fixture () in
            let password = password_fixture () in
            let+ r =
              Sapiens_backend.Account.get_user_by_email_and_password
                ~email
                ~password
            in
            check_user "is not found" (Error `Not_found) r)
      ; test_case
          "does not return the user if the password is not valid"
          (fun _switch () ->
            let* user_ = user_fixture () in
            let password_ = password_fixture ~v:"invalidpassword" () in
            let+ r =
              Sapiens_backend.Account.get_user_by_email_and_password
                ~email:user_.email
                ~password:password_
            in
            check_user "is not found" (Error `Not_found) r)
      ; test_case
          "returns the user if the email and password are valid"
          (fun _switch () ->
            let password_ = password_fixture ~v:"validpassword" () in
            let* user_ = user_fixture ~password:password_ () in
            let+ r =
              Sapiens_backend.Account.get_user_by_email_and_password
                ~email:user_.email
                ~password:password_
            in
            check_user "is a user" (Ok user_) r)
      ] )
  ; ( "get_user_by_id"
    , [ test_case "does not return the user if id is invalid" (fun _switch () ->
            let+ r = Sapiens_backend.Account.get_user_by_id 123 in
            check_user "is not found" (Error `Not_found) r)
      ; test_case "returns the user with the given id" (fun _switch () ->
            let* user_ = user_fixture () in
            let+ r = Sapiens_backend.Account.get_user_by_id user_.id in
            check_user "is a user" (Ok user_) r)
      ] )
  ; ( "get_user_by_username"
    , [ test_case
          "does not return the user if username is invalid"
          (fun _switch () ->
            let username = username_fixture () in
            let+ r = Sapiens_backend.Account.get_user_by_username username in
            check_user "is not found" (Error `Not_found) r)
      ; test_case "returns the user with the given username" (fun _switch () ->
            let* user_ = user_fixture () in
            let+ r =
              Sapiens_backend.Account.get_user_by_username user_.username
            in
            check_user "is a user" (Ok user_) r)
      ] )
  ; ( "User.Password.of_string"
    , [ test_case "validates password when given" (fun _switch () ->
            let r =
              Sapiens_backend.Account.User.Password.of_string "tooshort"
            in
            if Result.is_ok r then fail "should fail" else ();
            Lwt.return ())
      ; test_case "validates maximum value for security" (fun _switch () ->
            let s = String.init 256 (fun _ -> 'x') in
            let r = Sapiens_backend.Account.User.Password.of_string s in
            if Result.is_ok r then fail "should fail" else ();
            Lwt.return ())
      ] )
  ; ( "User.Email.of_string"
    , [ test_case "validates email when given" (fun _switch () ->
            let r =
              Sapiens_backend.Account.User.Email.of_string "not_an_email"
            in
            if Result.is_ok r then fail "should fail" else ();
            Lwt.return ())
      ; test_case "validates maximum value for security" (fun _switch () ->
            let s = String.init 61 (fun _ -> 'x') in
            let r = Sapiens_backend.Account.User.Email.of_string s in
            if Result.is_ok r then fail "should fail" else ();
            Lwt.return ())
      ] )
  ; ( "register_user"
    , [ test_case "validates e-mail uniqueness" (fun _switch () ->
            let username = username_fixture () in
            let email = email_fixture () in
            let password = password_fixture () in
            let* r =
              Sapiens_backend.Account.register_user ~username ~email ~password
            in
            if Result.is_error r then fail "should not fail" else ();
            let username = username_fixture () in
            let+ r =
              Sapiens_backend.Account.register_user ~username ~email ~password
            in
            check_user "already exists" (Error `Already_exists) r)
      ; test_case "validates username uniqueness" (fun _switch () ->
            let username = username_fixture () in
            let email = email_fixture () in
            let password = password_fixture () in
            let* r =
              Sapiens_backend.Account.register_user ~username ~email ~password
            in
            if Result.is_error r then fail "should not fail" else ();
            let email = email_fixture () in
            let+ r =
              Sapiens_backend.Account.register_user ~username ~email ~password
            in
            check_user "already exists" (Error `Already_exists) r)
      ] )
  ; ( "deliver_update_email_instructions"
    , [ test_case "requires email to change" (fun _switch () ->
            let password_ = password_fixture () in
            let* user_ = user_fixture ~password:password_ () in
            let+ r =
              Sapiens_backend.Account.deliver_update_email_instructions
                user_
                ~password:password_
                ~email:user_.email
                ~update_email_url_fn:(fun _ -> "")
              |> Lwt_result.map ignore
            in
            check
              (result unit error)
              "validation error"
              (Error
                 (`Validation_error "The email is the same as the current one."))
              r)
      ; test_case "validates e-mail uniqueness" (fun _switch () ->
            let* user1 = user_fixture () in
            let password_ = password_fixture () in
            let* user2 = user_fixture ~password:password_ () in
            let+ r =
              Sapiens_backend.Account.deliver_update_email_instructions
                user2
                ~password:password_
                ~email:user1.email
                ~update_email_url_fn:(fun _ -> "")
              |> Lwt_result.map ignore
            in
            check
              (result unit error)
              "email already exists"
              (Error `Already_exists)
              r)
      ; test_case "validates current password" (fun _switch () ->
            let password1 = password_fixture ~v:"strongpassword1" () in
            let password2 = password_fixture ~v:"strongpassword2" () in
            let* user_ = user_fixture ~password:password1 () in
            let email_ = email_fixture () in
            let+ r =
              Sapiens_backend.Account.deliver_update_email_instructions
                user_
                ~password:password2
                ~email:email_
                ~update_email_url_fn:(fun _ -> "")
              |> Lwt_result.map ignore
            in
            check
              (result unit error)
              "invalid password"
              (Error `Invalid_password)
              r)
      ; test_case "sends token through notification" (fun _switch () ->
            let password_ = password_fixture () in
            let* user_ = user_fixture ~password:password_ () in
            let email_ = email_fixture () in
            let* extracted_token =
              Test_support.extract_token (fun fn ->
                  Sapiens_backend.Account.deliver_update_email_instructions
                    user_
                    ~password:password_
                    ~email:email_
                    ~update_email_url_fn:fn)
            in
            let token =
              extracted_token
              |> Test_support.get_ok ~msg:"could not extract user token"
              |> Sapiens_backend.Token.of_string
              |> (fun token ->
                   Sapiens_backend.Token.decode_base64 token |> Result.get_ok)
              |> Sapiens_backend.Token.hash
              |> (fun token -> Sapiens_backend.Token.encode_base64 token)
              |> Result.get_ok
            in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_token token
              |> Test_support.get_lwt_ok ~msg:"user token was not found"
            in
            check (option email) "same email" (Some email_) user_token_.sent_to;
            check int "same id" user_.id user_token_.user_id;
            check
              context
              "same context"
              (Change_email user_.email)
              user_token_.context)
      ] )
  ; ( "update_user_email"
    , let setup () =
        let password_ = password_fixture () in
        let* user_ = user_fixture ~password:password_ () in
        let email_ = email_fixture () in
        let+ result =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Account.deliver_update_email_instructions
                user_
                ~password:password_
                ~email:email_
                ~update_email_url_fn:fn)
        in
        let t = result |> Result.get_ok |> Sapiens_backend.Token.of_string in
        user_, email_, t
      in
      [ test_case "updates the e-mail with a valid token" (fun _switch () ->
            let* user_, email_, token_ = setup () in
            let* changed_user_ =
              Sapiens_backend.Account.update_user_email ~token:token_ user_
            in
            (* This will fail because of password. Use it to debug
               Sapiens_backend.Account.update_user_email *)
            (* check (result user error) "is the user" (Ok user_) changed_user_; *)
            let changed_user_ = changed_user_ |> Result.get_ok in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
            in
            check (neg email) "not same email" user_.email changed_user_.email;
            check email "same email" changed_user_.email email_;
            check
              (neg (option ptime))
              "is not none"
              None
              changed_user_.confirmed_at;
            check
              (result user_token error)
              "not found"
              (Error `Not_found)
              user_token_)
      ; test_case "does not update e-mail with invalid token" (fun _switch () ->
            let* user_, _email_, _ = setup () in
            let* r =
              Sapiens_backend.Account.update_user_email
                ~token:(Sapiens_backend.Token.of_string "invalid")
                user_
            in
            let* refetched_user_ =
              Sapiens_backend.Account.get_user_by_id user_.id
              |> Test_support.get_lwt_ok ~msg:"user with id was not found"
            in
            let+ _user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
              |> Test_support.get_lwt_ok
                   ~msg:"user token with user_id was not found"
            in
            check (result user error) "is an error" (Error `Not_found) r;
            check email "same email" refetched_user_.email user_.email)
      ; test_case
          "does not update e-mail if user e-mail changed"
          (fun _switch () ->
            let* user_, _email_, token_ = setup () in
            let* r =
              Sapiens_backend.Account.update_user_email
                ~token:token_
                { user_ with
                  email =
                    Sapiens_backend.Account.User.Email.of_string
                      "current@example.com"
                    |> Result.get_ok
                }
            in
            let* refetched_user_ =
              Sapiens_backend.Account.get_user_by_id user_.id
              |> Test_support.get_lwt_ok ~msg:"user with id was not found"
            in
            let+ _user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
              |> Test_support.get_lwt_ok
                   ~msg:"user token with user_id was not found"
            in
            check (result user error) "is an error" (Error `Not_found) r;
            check email "same email" refetched_user_.email user_.email)
      ; test_case "does not update e-mail if token expired" (fun _switch () ->
            let* user_, _email_, token_ = setup () in
            let* () =
              update_user_tokens_date ()
              |> Test_support.get_lwt_ok
                   ~msg:"could not update user tokens date"
            in
            let* r =
              Sapiens_backend.Account.update_user_email
                ~token:token_
                { user_ with
                  email =
                    Sapiens_backend.Account.User.Email.of_string
                      "current@example.com"
                    |> Result.get_ok
                }
            in
            let* refetched_user_ =
              Sapiens_backend.Account.get_user_by_id user_.id
              |> Test_support.get_lwt_ok ~msg:"user with id was not found"
            in
            let+ _user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
              |> Test_support.get_lwt_ok
                   ~msg:"user token with user_id was not found"
            in
            check (result user error) "is an error" (Error `Not_found) r;
            check email "same email" refetched_user_.email user_.email)
      ] )
  ; ( "update_user_password"
    , [ test_case "validates current password" (fun _switch () ->
            let wrong_password = password_fixture ~v:"wrong-password" () in
            let new_password = password_fixture () in
            let* user_ = user_fixture () in
            let+ r =
              Sapiens_backend.Account.update_user_password
                ~current_password:wrong_password
                ~new_password
                user_
            in
            check (result user error) "is an error" (Error `Invalid_password) r)
      ; test_case "updates the password" (fun _switch () ->
            let old_password = password_fixture ~v:"old-password" () in
            let new_password = password_fixture ~v:"new-password" () in
            let* user_ = user_fixture ~password:old_password () in
            let* changed_user =
              Sapiens_backend.Account.update_user_password
                ~current_password:old_password
                ~new_password
                user_
            in
            (* This will fail because of password. Use it to debug
               Sapiens_backend.Account.update_user_email *)
            (* check (result user error) "is the user" (Ok user_) changed_user; *)
            let _ = Result.get_ok changed_user in
            let+ user_ =
              Sapiens_backend.Account.get_user_by_email_and_password
                ~email:user_.email
                ~password:new_password
            in
            check bool "is ok" true (Result.is_ok user_))
      ; test_case "deletes all tokens for the given user" (fun _switch () ->
            let old_password = password_fixture () in
            let new_password = password_fixture () in
            let* user_ = user_fixture ~password:old_password () in
            let* _ =
              Sapiens_backend.Account.generate_session_token user_
              |> Test_support.get_lwt_ok ~msg:"could not generate session token"
            in
            let* _ =
              Sapiens_backend.Account.update_user_password
                ~current_password:old_password
                ~new_password
                user_
              |> Test_support.get_lwt_ok ~msg:"could not update password"
            in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
            in
            check
              (result user_token error)
              "not found"
              (Error `Not_found)
              user_token_)
      ] )
  ; ( "generate_session_token"
    , [ test_case "generates a token" (fun _switch () ->
            let* user_ = user_fixture () in
            let* token_ =
              Sapiens_backend.Account.generate_session_token user_
            in
            let token_ = Result.get_ok token_ in
            let* user_token_ =
              Sapiens_backend.Account.User_token.get_by_token token_
            in
            check
              (neg (result user_token error))
              "is not not_found"
              (Error `Not_found)
              user_token_;
            let user_token_ = Result.get_ok user_token_ in
            let* user2 = user_fixture () in
            let+ r =
              Sapiens_backend.Account.User_token.insert
                { user_id = user2.id
                ; token =
                    Sapiens_backend.Token.decode_base64 token_ |> Result.get_ok
                ; context = Session
                ; sent_to = None
                }
            in
            check context "is a session token" user_token_.context Session;
            match r with
            | Error (`Internal_error _) ->
              ()
            | _ ->
              fail "should not create a token")
      ] )
  ; ( "get_user_by_session_token"
    , let setup () =
        let* user_ = user_fixture () in
        let+ token_ =
          Sapiens_backend.Account.generate_session_token user_
          |> Test_support.get_lwt_ok ~msg:"could not generate user session"
        in
        user_, token_
      in
      [ test_case "returns user by token" (fun _switch () ->
            let* user_, token_ = setup () in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_session_token token_
              |> Test_support.get_lwt_ok ~msg:"could not get user by session"
            in
            check int "is same id" user_.id session_user.id)
      ; test_case "does not return user for invalid token" (fun _switch () ->
            let* _user_, _ = setup () in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_session_token
                (Sapiens_backend.Token.of_string "invalid_token")
            in
            check
              (result user error)
              "is an error"
              (Error `Not_found)
              session_user)
      ; test_case "does not return user for expired token" (fun _switch () ->
            let* _user_, _token_ = setup () in
            let* () =
              update_user_tokens_date ()
              |> Test_support.get_lwt_ok ~msg:"could not update tokens date"
            in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_session_token
                (Sapiens_backend.Token.of_string "invalid_token")
            in
            check
              (result user error)
              "is an error"
              (Error `Not_found)
              session_user)
      ] )
  ; ( "delete_session_token"
    , [ test_case "deletes the token" (fun _switch () ->
            let* user_ = user_fixture () in
            let* token_ =
              Sapiens_backend.Account.generate_session_token user_
              |> Test_support.get_lwt_ok ~msg:"could not generate session token"
            in
            let* () =
              Sapiens_backend.Account.delete_session_token token_
              |> Test_support.get_lwt_ok ~msg:"could not delete session token"
            in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_session_token
                (Sapiens_backend.Token.of_string "invalid_token")
            in
            check
              (result user error)
              "is an error"
              (Error `Not_found)
              session_user)
      ] )
  ; ( "deliver_user_confirmation_instructions"
    , [ test_case "sends token through notification" (fun _switch () ->
            let* user_ = user_fixture () in
            let* token =
              Test_support.extract_token (fun fn ->
                  Sapiens_backend.Account.deliver_user_confirmation_instructions
                    user_
                    ~confirmation_url_fn:fn)
              |> Test_support.get_lwt_ok
                   ~msg:"could not extract user from token"
              |> Lwt.map Sapiens_backend.Token.of_string
              |> Lwt.map (fun token ->
                     Sapiens_backend.Token.decode_base64 token |> Result.get_ok)
              |> Lwt.map Sapiens_backend.Token.hash
              |> Lwt.map (fun token ->
                     Sapiens_backend.Token.encode_base64 token |> Result.get_ok)
            in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_token token
              |> Test_support.get_lwt_ok
                   ~msg:"user token with token was not found"
            in
            check
              (option email)
              "same email"
              (Some user_.email)
              user_token_.sent_to;
            check int "same id" user_.id user_token_.user_id;
            check context "same context" Confirm user_token_.context)
      ] )
  ; ( "confirm_user"
    , let setup () =
        let* user_ = user_fixture () in
        let+ result =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Account.deliver_user_confirmation_instructions
                user_
                ~confirmation_url_fn:fn)
        in
        let t = result |> Result.get_ok |> Sapiens_backend.Token.of_string in
        user_, t
      in
      [ test_case "confirms the e-mail with a valid token" (fun _switch () ->
            let* user_, token_ = setup () in
            let* changed_user_ = Sapiens_backend.Account.confirm_user token_ in
            (* This will fail because of password. Use it to debug
               Sapiens_backend.Account.update_user_email *)
            (* check (result user error) "is the user" (Ok user_) changed_user_; *)
            let changed_user_ = changed_user_ |> Result.get_ok in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
            in
            check
              (neg (option ptime))
              "is not none"
              None
              changed_user_.confirmed_at;
            check
              (result user_token error)
              "not found"
              (Error `Not_found)
              user_token_)
      ; test_case "does not confirm with invalid token" (fun _switch () ->
            let* user_, _token_ = setup () in
            let* r =
              Sapiens_backend.Account.confirm_user
                (Sapiens_backend.Token.of_string "invalid")
            in
            let* refetched_user_ =
              Sapiens_backend.Account.get_user_by_id user_.id
              |> Test_support.get_lwt_ok ~msg:"user with id was not found"
            in
            let+ _user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
              |> Test_support.get_lwt_ok
                   ~msg:"user token with user_id was not found"
            in
            check (result user error) "is an error" (Error `Not_found) r;
            check
              (option ptime)
              "not confirmed"
              None
              refetched_user_.confirmed_at)
      ; test_case "does not confirm e-mail if token expired" (fun _switch () ->
            let* user_, token_ = setup () in
            let* () =
              update_user_tokens_date ()
              |> Test_support.get_lwt_ok ~msg:"could not update tokens date"
            in
            let* r = Sapiens_backend.Account.confirm_user token_ in
            let* refetched_user_ =
              Sapiens_backend.Account.get_user_by_id user_.id
              |> Test_support.get_lwt_ok ~msg:"user with id was not found"
            in
            let+ _user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
              |> Test_support.get_lwt_ok
                   ~msg:"user token with user_id was not found"
            in
            check (result user error) "is an error" (Error `Not_found) r;
            check
              (option ptime)
              "not confirmed"
              None
              refetched_user_.confirmed_at)
      ] )
  ; ( "deliver_user_reset_password_instructions"
    , [ test_case "sends token through notification" (fun _switch () ->
            let* user_ = user_fixture () in
            let* token =
              Test_support.extract_token (fun fn ->
                  Sapiens_backend.Account
                  .deliver_user_reset_password_instructions
                    user_
                    ~reset_password_url_fn:fn)
              |> Test_support.get_lwt_ok
                   ~msg:"could not extract user from token"
              |> Lwt.map Sapiens_backend.Token.of_string
              |> Lwt.map (fun token ->
                     Sapiens_backend.Token.decode_base64 token |> Result.get_ok)
              |> Lwt.map Sapiens_backend.Token.hash
              |> Lwt.map (fun token ->
                     Sapiens_backend.Token.encode_base64 token |> Result.get_ok)
            in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_token token
              |> Test_support.get_lwt_ok
                   ~msg:"user token with token was not found"
            in
            check
              (option email)
              "same email"
              (Some user_.email)
              user_token_.sent_to;
            check int "same id" user_.id user_token_.user_id;
            check
              (option email)
              "same email"
              (Some user_.email)
              user_token_.sent_to;
            check context "same context" Reset_password user_token_.context)
      ] )
  ; ( "get_user_by_reset_password_token"
    , let setup () =
        let* user_ = user_fixture () in
        let+ token_ =
          Test_support.extract_token (fun fn ->
              Sapiens_backend.Account.deliver_user_reset_password_instructions
                user_
                ~reset_password_url_fn:fn)
          |> Test_support.get_lwt_ok ~msg:"could not extract user from token"
          |> Lwt.map Sapiens_backend.Token.of_string
        in
        user_, token_
      in
      [ test_case "returns user by token" (fun _switch () ->
            let* user_, token_ = setup () in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_reset_password_token token_
              |> Test_support.get_lwt_ok
                   ~msg:"user with reset password token was not found"
            in
            check int "is same id" user_.id session_user.id)
      ; test_case "does not return user for invalid token" (fun _switch () ->
            let* _user_, _ = setup () in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_reset_password_token
                (Sapiens_backend.Token.of_string "invalid_token")
            in
            check
              (result user error)
              "is an error"
              (Error `Not_found)
              session_user)
      ; test_case "does not return user for expired token" (fun _switch () ->
            let* _user_, _token_ = setup () in
            let* () =
              update_user_tokens_date ()
              |> Test_support.get_lwt_ok ~msg:"could not update tokens date"
            in
            let+ session_user =
              Sapiens_backend.Account.get_user_by_reset_password_token
                (Sapiens_backend.Token.of_string "invalid_token")
            in
            check
              (result user error)
              "is an error"
              (Error `Not_found)
              session_user)
      ] )
  ; ( "reset_user_password"
    , let setup () =
        let password_ = password_fixture ~v:"new-password" () in
        let+ user_ = user_fixture () in
        user_, password_
      in
      [ test_case "updates the password" (fun _switch () ->
            let* user_, password_ = setup () in
            let* _ =
              Sapiens_backend.Account.reset_user_password
                ~password:password_
                ~password_confirmation:password_
                user_
              |> Test_support.get_lwt_ok ~msg:"could not reset user password"
            in
            let+ updated_user =
              Sapiens_backend.Account.get_user_by_email_and_password
                ~email:user_.email
                ~password:password_
              |> Test_support.get_lwt_ok
                   ~msg:"user with email and password was not found"
            in
            check int "same id" user_.id updated_user.id)
      ; test_case "validates password confirmation" (fun _switch () ->
            let* user_, password_ = setup () in
            let wrong_password = password_fixture ~v:"wrong-password" () in
            let+ updated_user =
              Sapiens_backend.Account.reset_user_password
                ~password:password_
                ~password_confirmation:wrong_password
                user_
            in
            check_user
              "is validation error"
              (Error (`Validation_error "The passwords don't match."))
              updated_user)
      ; test_case "deletes all tokens for the given user" (fun _switch () ->
            let* user_, password_ = setup () in
            let* _ =
              Sapiens_backend.Account.generate_session_token user_
              |> Test_support.get_lwt_ok ~msg:"could not generate session token"
            in
            let* _ =
              Sapiens_backend.Account.reset_user_password
                ~password:password_
                ~password_confirmation:password_
                user_
              |> Test_support.get_lwt_ok ~msg:"could not reset user password"
            in
            let+ user_token_ =
              Sapiens_backend.Account.User_token.get_by_user_id user_.id
            in
            check
              (result user_token error)
              "not found"
              (Error `Not_found)
              user_token_)
      ] )
  ; ( "User.pp"
    , [ test_case "does not include the password" (fun _switch () ->
            let password_ = password_fixture ~v:"123456789abc" () in
            let+ user_ = user_fixture ~password:password_ () in
            let s =
              Format.asprintf "%a" Sapiens_backend.Account.User.pp user_
            in
            check
              bool
              "does not contain password"
              false
              (Std.String.find_sub ~sub:"123456789abc" s |> Option.is_some))
      ] )
  ; ( "delete_user"
    , [ test_case "deletes the user" (fun _switch () ->
            let password_ = password_fixture ~v:"123456789abc" () in
            let* user_ = user_fixture ~password:password_ () in
            let* _ =
              Sapiens_backend.Account.delete_user ~password:password_ user_
            in
            let+ r = Sapiens_backend.Account.get_user_by_id user_.id in
            check_user "is not found" (Error `Not_found) r)
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens - Account" suite
