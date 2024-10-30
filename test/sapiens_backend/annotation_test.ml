open Lwt.Syntax

let () =
  Test_support.setup_logger ~log_level:Logs.Warning ();
  Test_support.setup_rnd_generators ()

let test_case n f = Test_support.test_case_db n `Quick (fun _switch () -> f ())

let setup () =
  let+ dataset = Test_fixture_dataset.dataset_fixture () in
  dataset

let suite =
  [ ( "create_annotation_task"
    , [ test_case "can create an annotation task" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "returns an error if there is not enough datapoints available"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "returns an error if there is not enough datapoints available"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "returns an error if selected annotators are not dataset \
           collaborators"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "returns an error if number of annotation per user is superior to \
           annotators count"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "get_annotation_task_by_id"
    , [ test_case "returns the annotation task" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "list_user_annotation_tasks"
    , [ test_case "returns the user annotation tasks" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "list_dataset_annotation_tasks"
    , [ test_case "returns the dataset annotation tasks" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "can filter annotation tasks by state (in progress, canceled, \
           completed)"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "cancel_annotation_task"
    , [ test_case "cancels the annotation task" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "returns an error if the annotation task is not in progress"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "complete_annotation_task"
    , [ test_case "completes the annotation task" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "returns an error if the annotation task is not in progress"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "creates new features in the dataset for the annotations"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case
          "does not create new features in the dataset for annotation that \
           don't have enough identical annotations"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case "maps the created features to the annotations" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "annotate_datapoint"
    , [ test_case "creates an annotation" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case "returns an error if the annotation is invalid" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "get_annotation_task_history"
    , [ test_case
          "returns the history of annotations for the annotation task"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case "returns the annotation ordered by creation dates." (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "get_annotation_task_user_history"
    , [ test_case
          "returns the history of annotations for the annotation task for the \
           given user"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ; test_case "returns the annotation ordered by creation dates." (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "revert_annotation"
    , [ test_case "reverts the annotation" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "returns an error if the annotation was not created by the user"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "get_annotation_task_progress"
    , [ test_case "returns the annotation task progress" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "get_annotation_task_user_progress"
    , [ test_case
          "returns the annotation task progress for the given user"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "get_current_datapoint_to_annotate"
    , [ test_case "returns the current datapoint to annotate" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ; test_case
          "changes when the user annotates the current datapoint"
          (fun () -> (* TODO(tmattio): Implement unit test *)
                     Lwt.return ())
      ] )
  ; ( "get_previous_annotation_task_datapoint"
    , [ test_case "returns the previous datapoint to annotate" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ; ( "get_next_annotation_task_datapoint"
    , [ test_case "returns the next datapoint to annotate" (fun () ->
            (* TODO(tmattio): Implement unit test *)
            Lwt.return ())
      ] )
  ]

let () = Lwt_main.run @@ Alcotest_lwt.run "sapiens - Annotation" suite
