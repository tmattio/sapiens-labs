let setup_rnd_generators () = Mirage_crypto_rng_unix.initialize ()

let setup_logger ?(log_level = Logs.Info) () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_level (Some log_level);
  Logs.set_reporter (Logs_fmt.reporter ~app:Fmt.stdout ())

let test_case_db n s f =
  let open Lwt.Syntax in
  Alcotest_lwt.test_case n s (fun switch () ->
      let* result = Sapiens_backend.Repo.clean_all () in
      (* Fail if database clean failed *)
      let _ok = Result.get_ok result in
      f switch ())

let test_case_db_quick n = test_case_db n `Quick

let get_lwt_ok ~msg =
  Lwt.map (fun r -> try Result.get_ok r with _ -> Alcotest.fail msg)

let get_ok ~msg r = try Result.get_ok r with _ -> Alcotest.fail msg

let extract_token fn =
  let open Lwt_result.Syntax in
  let+ _email, body = fn (fun token -> "[TOKEN]" ^ token ^ "[TOKEN]") in
  match Std.String.cuts ~sep:"[TOKEN]" body with
  | [ _; token; _ ] ->
    token
  | _ ->
    failwith "token extraction failed"
