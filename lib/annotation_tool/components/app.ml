module Unsupported = struct
  let make feat =
    let open Tyxml.Html in
    div [ txt ("This feature type is not supported yet: " ^ feat) ]
end

module Input_features_dispatcher = struct
  let dispatch = function
    | Sapiens_common.Datapoint.Image { feature = { url; _ }; _ } ->
      Tool_image.make url
    | Sapiens_common.Datapoint.Image_seq _ ->
      Unsupported.make "Image_seq"
    | Sapiens_common.Datapoint.Text { feature = { text }; _ } ->
      Tool_text.make text
    | Sapiens_common.Datapoint.Bbox _ ->
      Unsupported.make "Bbox"
    | Sapiens_common.Datapoint.Bbox_seq _ ->
      Unsupported.make "Bbox_seq"
    | Sapiens_common.Datapoint.Label _ ->
      Unsupported.make "Label"
    | Sapiens_common.Datapoint.Label_seq _ ->
      Unsupported.make "Label_seq"
    | Sapiens_common.Datapoint.Number _ ->
      Unsupported.make "Number"
    | Sapiens_common.Datapoint.Number_seq _ ->
      Unsupported.make "Number_seq"
    | Sapiens_common.Datapoint.Tokens _ ->
      Unsupported.make "Tokens"
    | Sapiens_common.Datapoint.Entity _ ->
      Unsupported.make "Entity"
    | Sapiens_common.Datapoint.Entity_seq _ ->
      Unsupported.make "Entity_seq"

  let make features =
    let open Tyxml.Html in
    ul
      ~a:[ a_class [ "divide-y divide-gray-200" ] ]
      (List.map
         (fun (feature : Sapiens_common.Datapoint.feature) ->
           li
             [ div
                 ~a:[ a_class [ "px-4 py-4 sm:px-6" ] ]
                 [ p
                     ~a:
                       [ a_class
                           [ "text-sm font-medium text-indigo-600 truncate \
                              uppercase"
                           ]
                       ]
                     [ (* Add feature name here *) ]
                 ; div ~a:[ a_class [ "mt-2" ] ] [ dispatch feature ]
                 ]
             ])
         features)
end

module Output_features_dispatcher = struct
  let make ~on_change features definitions =
    let hashtbl = Helper.hashtbl_of_features features in
    let on_change () =
      let features = Helper.features_of_hashtbl hashtbl in
      on_change features
    in
    List.map
      (fun el ->
        let title =
          Sapiens_common.Datapoint.Feature_name.to_string
            el.Sapiens_common.Datapoint.feature_name
        in
        match el.spec with
        | Sapiens_common.Datapoint.Image_def _ ->
          Unsupported.make "Image_def"
        | Sapiens_common.Datapoint.Text_def _ ->
          Unsupported.make "Text_def"
        | Sapiens_common.Datapoint.Bbox_def _ ->
          Unsupported.make "Bbox_def"
        | Sapiens_common.Datapoint.Label_def { classes } ->
          let value = Helper.get_label_feat hashtbl el.id in
          let on_change x =
            Helper.set_label_feat hashtbl el.id x |> on_change
          in
          Tool_radios.make ~title ~classes ~on_change value
        | Sapiens_common.Datapoint.Number_def { min; max } ->
          let value = Helper.get_number_feat hashtbl el.id in
          let on_change x =
            Helper.set_number_feat hashtbl el.id x |> on_change
          in
          Tool_number.make ~title ?min ?max ~on_change value
        | Sapiens_common.Datapoint.Tokens_def _ ->
          Unsupported.make "Tokens_def"
        | Sapiens_common.Datapoint.Entity_def _ ->
          Unsupported.make "Entity_def"
        | Sapiens_common.Datapoint.(
            Sequence_def
              { min_count
              ; max_count
              ; element_definition = Label_def { classes }
              ; _
              }) ->
          let value = Helper.get_label_seq_feat hashtbl el.id in
          let on_change x =
            Helper.set_label_seq_feat hashtbl el.id x |> on_change
          in
          Tool_checkboxes.make
            ~title
            ~classes
            ?min_count
            ?max_count
            ~on_change
            value
        | Sapiens_common.Datapoint.(Sequence_def _) ->
          Unsupported.make "Sequence_def")
      definitions
end

let make ~task_id (t : Sapiens_common.Annotation.user_annotation_task) =
  let open Tyxml.Html in
  let annotation_index = Helper.index_first_non_annotated t.annotations in
  let total = Helper.count_annotations t.annotations in
  let annotations, set_annotations = Use.state t.annotations in
  let index, set_index = Use.state annotation_index in
  let _error, set_error = Use.state None in
  let on_next () =
    match Lwd.peek index with
    | Some index ->
      set_index (fun _ -> Some (min (total - 1) (index + 1)))
    | None ->
      ()
  in
  let on_previous () =
    match Lwd.peek index with
    | Some index ->
      set_index (fun _ -> Some (max 0 (index - 1)))
    | None ->
      set_index (fun _ -> Some (List.length t.annotations - 1))
  in
  let on_validate () =
    match Lwd.peek index with
    | Some index ->
      let annotation = List.nth (Lwd.peek annotations) index in
      let callback result =
        match result with
        | Ok () ->
          set_annotations (fun annotations ->
              List.map
                (fun el ->
                  if
                    Int.equal
                      el.Sapiens_common.Annotation.Annotation.datapoint_id
                      annotation.datapoint_id
                  then
                    { el with annotated_at = Some Ptime.epoch }
                  else
                    el)
                annotations);
          on_next ()
        | Error error ->
          set_error (fun _ -> Some error)
      in
      let json =
        (let open Sapiens_common.Annotation in
        user_annotation_to_yojson
          { datapoint_id = annotation.datapoint_id
          ; annotations = annotation.annotations
          })
        |> Yojson.Safe.to_string
      in
      Io.send_annotations ~callback task_id json
    | None ->
      ()
  in
  let on_change datapoint_id features =
    set_annotations (fun annotations ->
        List.map
          (fun el ->
            if
              Int.equal
                el.Sapiens_common.Annotation.Annotation.datapoint_id
                datapoint_id
            then
              { el with annotations = features }
            else
              el)
          annotations)
  in
  Layout.make
    ~on_previous
    ~on_validate
    ~on_next
    ~task:t
    [ Lwd.bind (Lwd.get index) ~f:(function
          | Some index ->
            Lwd.bind (Lwd.get annotations) ~f:(fun annotations ->
                let annotation = List.nth annotations index in
                let input_features = annotation.input_features in
                let features = annotation.annotations in
                let output_definitions = t.output_definitions in
                div
                  [ div
                      ~a:
                        [ class_
                            "px-4 py-5 sm:p-6 max-h-96 overflow-y-auto sticky \
                             top-0 bg-white z-10 rounded-lg"
                        ]
                      [ Input_features_dispatcher.make input_features ]
                  ; div
                      ~a:[ class_ "px-4 py-5 sm:p-6" ]
                      (Output_features_dispatcher.make
                         ~on_change:(on_change annotation.datapoint_id)
                         features
                         output_definitions)
                  ])
          | None ->
            div
              ~a:[ class_ "px-4 py-5 sm:p-6" ]
              [ span
                  ~a:[ class_ "text-lg leading-6 font-medium text-gray-900" ]
                  [ txt "🎉 You finished your annotations!" ]
              ])
    ]
