open Lwt.Syntax
open Test_testable_dataset
open Test_fixture_dataset

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n f = Test_support.test_case_db n `Quick (fun _switch () -> f ())

let check_dataset = Alcotest.check (Alcotest.result dataset error)

let setup () =
  let+ dataset = dataset_fixture () in
  dataset

let suite =
  [ ( "Image"
    , [ test_case "can create image feature" (fun () -> (* TODO *)
                                                        Lwt.return ())
      ] )
  ; ( "Text"
    , [ test_case "can create text feature" (fun () -> (* TODO *)
                                                       Lwt.return ())
      ] )
  ; ( "Bbox"
    , [ test_case "can create bbox feature" (fun () -> (* TODO *)
                                                       Lwt.return ())
      ; test_case
          "validates that the bbox label is allowed by the feature definition"
          (fun () -> (* TODO *)
                     Lwt.return ())
      ] )
  ; ( "Tokens"
    , [ test_case "can create tokens feature" (fun () ->
            (* TODO *)
            Lwt.return ())
      ; test_case
          "validates that the tokens are within the text characters"
          (fun () -> (* TODO *)
                     Lwt.return ())
      ; test_case "validates that the tokens are not overlapping" (fun () ->
            (* TODO *)
            Lwt.return ())
      ] )
  ; ( "Entity"
    , [ test_case "can create entity feature" (fun () ->
            (* TODO *)
            Lwt.return ())
      ; test_case
          "validates that the entity is within the token indexes"
          (fun () -> (* TODO *)
                     Lwt.return ())
      ; test_case
          "validates that the entity label is allowed by the feature definition"
          (fun () -> (* TODO *)
                     Lwt.return ())
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens - Dataset" suite
