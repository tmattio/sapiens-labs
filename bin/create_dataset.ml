open Sapiens_dataset

let setup_logger ?(log_level = Logs.Debug) () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_level (Some log_level);
  Logs.set_reporter (Logs_fmt.reporter ~app:Fmt.stdout ())

let () =
  setup_logger ();
  let name = Sys.argv.(1) in
  let dataset =
    List.find
      (fun el ->
        let module D = (val el : Dataset) in
        D.name = name)
      datasets
  in
  let result = create_dataset dataset |> Lwt_main.run in
  match result with
  | Ok _ ->
    ()
  | Error `Already_exists ->
    print_endline "The dataset already exists";
    exit 1
  | Error (`Internal_error err) ->
    print_endline err;
    exit 1
  | Error `Permission_denied ->
    print_endline "Permission denied";
    exit 1
  | Error `Not_found ->
    print_endline "Not_found";
    exit 1
  | Error (`Validation_error err) ->
    print_endline err;
    exit 1
