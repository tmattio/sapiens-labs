let new_ ~dataset ~user ~definitions ?alert () =
  let open Tyxml.Html in
  Dataset_layout.make
    ~title:"Create annotation task · Sapiens"
    ~dataset
    ~user
    ~active:Tasks
    [ (match alert with Some alert -> div ~a:[ a_class [ "mb-8" ] ] [ Alert.make alert ] | None -> div [])
    ; form
        ~a:[ a_action ("/datasets/" ^ string_of_int dataset.id ^ "/tasks"); a_method `Post ]
        [ div
            [ div
                [ div
                    ~a:[ a_class [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:pt-5" ] ]
                    [ label
                        ~a:
                          [ a_label_for "task-name"
                          ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                          ]
                        [ txt "Task Name" ]
                    ; div
                        ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                        [ input
                            ~a:
                              [ a_id "task-name"
                              ; a_name "name"
                              ; a_input_type `Text
                              ; a_required ()
                              ; a_class
                                  [ "max-w-lg border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 \
                                     w-full sm:text-sm"
                                  ]
                              ]
                            ()
                        ; p
                            ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                            [ txt "Identifier of the tasks for the annotators." ]
                        ]
                    ]
                ; div
                    ~a:
                      [ a_class
                          [ "mt-6 sm:mt-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t \
                             sm:border-gray-200 sm:pt-5"
                          ]
                      ]
                    [ label
                        ~a:
                          [ a_label_for "guideline-url"
                          ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                          ]
                        [ txt "Guidelines URL" ]
                    ; div
                        ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                        [ input
                            ~a:
                              [ a_id "guideline-url"
                              ; a_name "guidelines_url"
                              ; a_input_type `Text
                              ; a_class
                                  [ "max-w-lg border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 \
                                     w-full sm:text-sm"
                                  ]
                              ]
                            ()
                        ; p
                            ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                            [ txt "The annotators will see the guidelines in the annotation tool." ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "mt-6 sm:mt-5 sm:border-t sm:border-gray-200 sm:pt-5" ] ]
                    [ div
                        ~a:[ a_role [ "group" ]; a_aria "labelledby" [ "label-notifications" ] ]
                        [ div
                            ~a:[ a_class [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-center" ] ]
                            [ div
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "text-base leading-6 font-medium text-gray-900 sm:text-sm sm:leading-5 \
                                             sm:text-gray-700"
                                          ]
                                      ; a_id "label-notifications"
                                      ]
                                    [ txt "Assignee" ]
                                ]
                            ; div
                                ~a:[ a_class [ "sm:col-span-2" ] ]
                                [ div
                                    ~a:[ a_class [ "max-w-lg" ] ]
                                    (ListLabels.map
                                       ~f:(fun (collaborator : Sapiens_backend.Account.User.t) ->
                                         div
                                           ~a:[ a_class [ "mt-4" ] ]
                                           [ div
                                               ~a:[ a_class [ "flex items-center" ] ]
                                               [ input
                                                   ~a:
                                                     [ a_id ("collaborator-" ^ string_of_int collaborator.id)
                                                     ; a_value (string_of_int collaborator.id)
                                                     ; a_name "assignee"
                                                     ; a_input_type `Radio
                                                     ; a_class
                                                         [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 \
                                                            border-gray-300"
                                                         ]
                                                     ]
                                                   ()
                                               ; label
                                                   ~a:
                                                     [ a_label_for ("collaborator-" ^ string_of_int collaborator.id)
                                                     ; a_class [ "ml-3" ]
                                                     ]
                                                   [ span
                                                       ~a:
                                                         [ a_class
                                                             [ "block text-sm leading-5 font-medium text-gray-700" ]
                                                         ]
                                                       [ txt
                                                           (Sapiens_backend.Account.User.Username.to_string
                                                              collaborator.username)
                                                       ]
                                                   ]
                                               ]
                                           ])
                                       (dataset.user :: dataset.collaborators))
                                ]
                            ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "mt-6 sm:mt-5 sm:border-t sm:border-gray-200 sm:pt-5" ] ]
                    [ div
                        ~a:[ a_role [ "group" ]; a_aria "labelledby" [ "label-notifications" ] ]
                        [ div
                            ~a:[ a_class [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-center" ] ]
                            [ div
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "text-base leading-6 font-medium text-gray-900 sm:text-sm sm:leading-5 \
                                             sm:text-gray-700"
                                          ]
                                      ]
                                    [ txt "Input Features" ]
                                ]
                            ; div
                                ~a:[ a_class [ "sm:col-span-2" ] ]
                                [ div
                                    ~a:[ a_class [ "max-w-lg" ] ]
                                    (ListLabels.map
                                       ~f:(fun (def : Sapiens_backend.Dataset.Datapoint.definition) ->
                                         div
                                           ~a:[ a_class [ "mt-4" ] ]
                                           [ div
                                               ~a:[ a_class [ "relative flex items-start" ] ]
                                               [ div
                                                   ~a:[ a_class [ "flex items-center h-5" ] ]
                                                   [ input
                                                       ~a:
                                                         [ a_id ("input-" ^ string_of_int def.id)
                                                         ; a_value (string_of_int def.id)
                                                         ; a_name "input_features"
                                                         ; a_input_type `Checkbox
                                                         ; a_class
                                                             [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 \
                                                                border-gray-300 rounded"
                                                             ]
                                                         ]
                                                       ()
                                                   ]
                                               ; div
                                                   ~a:[ a_class [ "ml-3 text-sm leading-5" ] ]
                                                   [ label
                                                       ~a:
                                                         [ a_label_for ("input-" ^ string_of_int def.id)
                                                         ; a_class [ "font-medium text-gray-700" ]
                                                         ]
                                                       [ txt
                                                           (Sapiens_backend.Dataset.Datapoint.Feature_name.to_string
                                                              def.feature_name)
                                                       ]
                                                   ]
                                               ]
                                           ])
                                       definitions)
                                ]
                            ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "mt-6 sm:mt-5 sm:border-t sm:border-gray-200 sm:pt-5" ] ]
                    [ div
                        ~a:[ a_role [ "group" ]; a_aria "labelledby" [ "label-notifications" ] ]
                        [ div
                            ~a:[ a_class [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-center" ] ]
                            [ div
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "text-base leading-6 font-medium text-gray-900 sm:text-sm sm:leading-5 \
                                             sm:text-gray-700"
                                          ]
                                      ]
                                    [ txt "Output Features" ]
                                ]
                            ; div
                                ~a:[ a_class [ "sm:col-span-2" ] ]
                                [ div
                                    ~a:[ a_class [ "max-w-lg" ] ]
                                    (ListLabels.map
                                       ~f:(fun (def : Sapiens_backend.Dataset.Datapoint.definition) ->
                                         div
                                           ~a:[ a_class [ "mt-4" ] ]
                                           [ div
                                               ~a:[ a_class [ "relative flex items-start" ] ]
                                               [ div
                                                   ~a:[ a_class [ "flex items-center h-5" ] ]
                                                   [ input
                                                       ~a:
                                                         [ a_id ("output-" ^ string_of_int def.id)
                                                         ; a_value (string_of_int def.id)
                                                         ; a_name "output_features"
                                                         ; a_input_type `Checkbox
                                                         ; a_class
                                                             [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 \
                                                                border-gray-300 rounded"
                                                             ]
                                                         ]
                                                       ()
                                                   ]
                                               ; div
                                                   ~a:[ a_class [ "ml-3 text-sm leading-5" ] ]
                                                   [ label
                                                       ~a:
                                                         [ a_label_for ("output-" ^ string_of_int def.id)
                                                         ; a_class [ "font-medium text-gray-700" ]
                                                         ]
                                                       [ txt
                                                           (Sapiens_backend.Dataset.Datapoint.Feature_name.to_string
                                                              def.feature_name)
                                                       ]
                                                   ]
                                               ]
                                           ])
                                       definitions)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ; div
            ~a:[ a_class [ "mt-8 border-t border-gray-200 pt-5" ] ]
            [ div
                ~a:[ a_class [ "flex justify-end" ] ]
                [ span
                    ~a:[ a_class [ "ml-3 inline-flex rounded-md shadow-sm" ] ]
                    [ button
                        ~a:
                          [ a_button_type `Submit
                          ; a_class
                              [ "inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm \
                                 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none \
                                 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                              ]
                          ]
                        [ txt "Create task" ]
                    ]
                ]
            ]
        ]
    ]

let index ~dataset ~user ~tasks ~progress:progress_ ?alert:_ () =
  let open Tyxml.Html in
  Dataset_layout.make
    ~title:"Dataset tasks · Sapiens"
    ~dataset
    ~user
    ~active:Tasks
    [ div
        ~a:[ a_class [ "w-full text-right mb-4" ] ]
        [ span
            ~a:[ a_class [ "shadow-sm rounded-md" ] ]
            [ a
                ~a:
                  [ a_href ("/datasets/" ^ string_of_int dataset.id ^ "/tasks/new")
                  ; a_class
                      [ "inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 font-medium \
                         rounded-md text-white bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:ring-indigo \
                         focus:border-indigo-700 active:bg-indigo-700 transition duration-150 ease-in-out"
                      ]
                  ]
                [ txt "Create a task" ]
            ]
        ]
    ; Task_table.make ~progress:progress_ tasks
    ]
