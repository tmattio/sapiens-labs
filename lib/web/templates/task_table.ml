let make ~progress:progress_ tasks =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "flex flex-col" ] ]
    [ div
        ~a:[ a_class [ "-my-2 py-2 overflow-x-auto sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8" ] ]
        [ div
            ~a:
              [ a_class
                  [ "align-middle inline-block min-w-full shadow overflow-hidden sm:rounded-lg border-b border-gray-200"
                  ]
              ]
            [ table
                ~a:[ a_class [ "min-w-full" ] ]
                ~thead:
                  (thead
                     [ tr
                         [ th
                             ~a:
                               [ a_class
                                   [ "px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 \
                                      font-medium text-gray-500 uppercase tracking-wider"
                                   ]
                               ]
                             [ txt "Name" ]
                         ; th
                             ~a:
                               [ a_class
                                   [ "px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 \
                                      font-medium text-gray-500 uppercase tracking-wider"
                                   ]
                               ]
                             [ txt "Status" ]
                         ; th ~a:[ a_class [ "px-6 py-3 border-b border-gray-200 bg-gray-50" ] ] []
                         ]
                     ])
                (ListLabels.map
                   ~f:(fun (task : Sapiens_backend.Annotation.Task.t) ->
                     tr
                       [ td
                           ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                           [ div
                               ~a:[ a_class [ "text-sm leading-5 text-gray-900" ] ]
                               [ txt (Sapiens_backend.Annotation.Task.Name.to_string task.name) ]
                           ]
                       ; td
                           ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                           [ (match task.state with
                             | In_progress ->
                               Progress_bar.make
                                 ~label:"In progress"
                                 ~percentage:
                                   (List.assoc task.id progress_
                                   |> Sapiens_backend.Annotation.Progress.compute
                                   |> ( *. ) 100.
                                   |> int_of_float)
                                 ~color:`blue
                                 ()
                             | Canceled ->
                               Progress_bar.make
                                 ~label:"Canceled"
                                 ~percentage:
                                   (List.assoc task.id progress_
                                   |> Sapiens_backend.Annotation.Progress.compute
                                   |> ( *. ) 100.
                                   |> int_of_float)
                                 ~color:`red
                                 ()
                             | Completed ->
                               Progress_bar.make
                                 ~label:"Completed"
                                 ~percentage:
                                   (List.assoc task.id progress_
                                   |> Sapiens_backend.Annotation.Progress.compute
                                   |> ( *. ) 100.
                                   |> int_of_float)
                                 ~color:`green
                                 ())
                           ]
                       ; td
                           ~a:
                             [ a_class
                                 [ "px-6 py-4 whitespace-nowrap text-right border-b border-gray-200 text-sm leading-5 \
                                    font-medium"
                                 ]
                             ]
                           [ form
                               ~a:
                                 [ a_action ("/datasets/" ^ string_of_int task.dataset_id ^ "/tasks/complete")
                                 ; a_method `Post
                                 ; a_class [ "inline" ]
                                 ]
                               [ input
                                   ~a:
                                     [ a_id "task_id"
                                     ; a_name "task_id"
                                     ; a_input_type `Hidden
                                     ; a_value (string_of_int task.id)
                                     ]
                                   ()
                               ; button
                                   ~a:[ a_button_type `Submit; a_class [ "text-indigo-600 hover:text-indigo-900" ] ]
                                   [ txt "Complete" ]
                               ]
                           ; form
                               ~a:
                                 [ a_action ("/datasets/" ^ string_of_int task.dataset_id ^ "/tasks/cancel")
                                 ; a_method `Post
                                 ; a_class [ "inline" ]
                                 ]
                               [ input
                                   ~a:
                                     [ a_id "task_id"
                                     ; a_name "task_id"
                                     ; a_input_type `Hidden
                                     ; a_value (string_of_int task.id)
                                     ]
                                   ()
                               ; button ~a:[ a_class [ "ml-4 text-indigo-600 hover:text-indigo-900" ] ] [ txt "Cancel" ]
                               ]
                           ]
                       ])
                   tasks)
            ]
        ]
    ]
