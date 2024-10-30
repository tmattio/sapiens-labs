let index ~user ?alert ~datasets () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Sapiens"
    [ Layout.navbar ~user ~active:Datasets ()
    ; (match alert with Some alert -> div ~a:[ a_class [ "my-4" ] ] [ Alert.make alert ] | None -> div [])
    ; header
        ~a:[ a_class [ "pt-10 pb-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "md:flex md:items-center md:justify-between" ] ]
            [ div
                ~a:[ a_class [ "flex-1 min-w-0" ] ]
                [ h1
                    ~a:[ a_class [ "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate" ] ]
                    [ txt "Your datasets" ]
                ]
            ; (match datasets with
              | [] ->
                div []
              | _ ->
                div
                  ~a:[ a_class [ "mt-4 flex md:mt-0 md:ml-4" ] ]
                  [ span
                      ~a:[ a_class [ "shadow-sm rounded-md" ] ]
                      [ a
                          ~a:
                            [ a_href "/datasets/new"
                            ; a_class
                                [ "inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 \
                                   font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                                   focus:outline-none focus:ring-indigo focus:border-indigo-700 active:bg-indigo-700 \
                                   transition duration-150 ease-in-out"
                                ]
                            ]
                          [ txt "Create a dataset" ]
                      ]
                  ])
            ]
        ]
    ; Layout.content
        [ (match datasets with
          | [] ->
            div
              ~a:[ a_class [ "mx-auto max-w-xl" ] ]
              [ div
                  [ div
                      ~a:[ a_class [ "mx-auto flex items-center justify-center" ] ]
                      [ img ~src:"/undraw_empty_street_sfxm.svg" ~alt:"No datasets" () ]
                  ; div
                      ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                      [ h3
                          ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                          [ txt "No dataset" ]
                      ; div
                          ~a:[ a_class [ "mt-2" ] ]
                          [ p
                              ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                              [ txt
                                  "You don't have any dataset. Once you have created your first dataset, it will be \
                                   listed here."
                              ]
                          ]
                      ]
                  ]
              ; div
                  ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
                  [ span
                      ~a:[ a_class [ "max-w-md mx-auto flex w-full rounded-md shadow-sm" ] ]
                      [ a
                          ~a:
                            [ a_href "/datasets/new"
                            ; a_class
                                [ "inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 \
                                   bg-indigo-600 text-base leading-6 font-medium text-white shadow-sm \
                                   hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:ring-indigo \
                                   transition ease-in-out duration-150 sm:text-sm sm:leading-5"
                                ]
                            ]
                          [ txt "Create your first dataset" ]
                      ]
                  ]
              ]
          | _ ->
            Dataset_card_grid.make datasets)
        ]
    ]

let new_ ~user ?alert () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Create a dataset · Sapiens"
    [ Layout.navbar ~user ()
    ; Layout.page_title
        ~title:"Create a new dataset"
        ~subtitle:"A dataset contains various type of data. Once your dataset is created, you upload data to it."
        ()
    ; Layout.content
        [ (match alert with Some alert -> div ~a:[ a_class [ "mb-8" ] ] [ Alert.make alert ] | None -> div [])
        ; form
            ~a:[ a_action "/datasets"; a_method `Post ]
            [ div
                [ div
                    [ div
                        ~a:
                          [ a_class
                              [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5"
                              ]
                          ]
                        [ label
                            ~a:
                              [ a_label_for "dataset-name"
                              ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                              ]
                            [ txt "Dataset Name" ]
                        ; div
                            ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                            [ input
                                ~a:
                                  [ a_id "dataset-name"
                                  ; a_name "name"
                                  ; a_input_type `Text
                                  ; a_required ()
                                  ; a_class
                                      [ "max-w-lg py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 \
                                         focus:border-indigo-500 border-gray-300 rounded-md"
                                      ]
                                  ]
                                ()
                            ; p
                                ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                                [ txt "A good dataset name is short and easy to remember." ]
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
                              [ a_label_for "description"
                              ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                              ]
                            [ txt "Description" ]
                        ; div
                            ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                            [ div
                                ~a:[ a_class [ "max-w-lg flex rounded-md shadow-sm" ] ]
                                [ textarea
                                    ~a:
                                      [ a_id "description"
                                      ; a_name "description"
                                      ; a_rows 3
                                      ; a_class
                                          [ "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full \
                                             sm:text-sm border-gray-300 rounded-md"
                                          ]
                                      ]
                                    (txt "")
                                ]
                            ; p
                                ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                                [ txt "Write a few words to describe your dataset." ]
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
                                        [ txt "Visibility" ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "sm:col-span-2" ] ]
                                    [ div
                                        ~a:[ a_class [ "max-w-lg" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex items-center" ] ]
                                            [ input
                                                ~a:
                                                  [ a_id "visibility-public"
                                                  ; a_name "form-input push_notifications"
                                                  ; a_input_type `Radio
                                                  ; a_required ()
                                                  ; a_class
                                                      [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300"
                                                      ]
                                                  ]
                                                ()
                                            ; div
                                                ~a:[ a_class [ "pl-4 text-sm leading-5" ] ]
                                                [ label
                                                    ~a:[ a_label_for "visibility-public"; a_class [ "ml-3" ] ]
                                                    [ span
                                                        ~a:[ a_class [ "block font-medium text-gray-700" ] ]
                                                        [ txt "Public" ]
                                                    ]
                                                ; p
                                                    ~a:[ a_class [ "text-gray-500" ] ]
                                                    [ txt "Your dataset will be visible to everyone." ]
                                                ]
                                            ]
                                        ; div
                                            ~a:[ a_class [ "mt-4 flex items-center" ] ]
                                            [ input
                                                ~a:
                                                  [ a_id "visibility-private"
                                                  ; a_name "form-input push_notifications"
                                                  ; a_required ()
                                                  ; a_input_type `Radio
                                                  ; a_class
                                                      [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300"
                                                      ]
                                                  ]
                                                ()
                                            ; div
                                                ~a:[ a_class [ "pl-4 text-sm leading-5" ] ]
                                                [ label
                                                    ~a:[ a_label_for "visibility-private"; a_class [ "ml-3" ] ]
                                                    [ span
                                                        ~a:
                                                          [ a_class
                                                              [ "block text-sm leading-5 font-medium text-gray-700" ]
                                                          ]
                                                        [ txt "Private" ]
                                                    ]
                                                ; p
                                                    ~a:[ a_class [ "text-gray-500" ] ]
                                                    [ txt "Only you will see your dataset." ]
                                                ]
                                            ]
                                        ]
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
                                  [ "inline-flex justify-center py-2 px-4 border border-transparent rounded-md \
                                     shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                     focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                  ]
                              ]
                            [ txt "Create dataset" ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let show_tasks ~dataset ~user ~tasks:_ ?alert:_ () =
  let is_dataset_empty = true in
  Dataset_layout.make
    ~title:"Dataset suggestions · Sapiens"
    ~dataset
    ~user
    ~active:Tasks
    (if is_dataset_empty then
       [ Dataset_empty.make ~dataset ]
    else
      [])

let show_insights ~dataset ~user ?alert:_ () =
  let is_dataset_empty = true in
  Dataset_layout.make
    ~title:"Dataset insights · Sapiens"
    ~dataset
    ~user
    ~active:Insights
    (if is_dataset_empty then
       [ Dataset_empty.make ~dataset ]
    else
      [])

let upload ~user ~dataset ?alert:_ () = Dataset_layout.make ~title:"Upload dataset · Sapiens" ~dataset ~user []
