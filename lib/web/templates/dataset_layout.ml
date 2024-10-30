type nav_item =
  | Overview
  | Tasks
  | Insights
  | Settings

let nav_items =
  [ Overview, "Overview", ""
  ; Tasks, "Tasks", "/tasks"
  ; Insights, "Insights", "/insights"
  ; Settings, "Settings", "/settings"
  ]

let make ~title:title_ ~dataset ~user ?(active : nav_item option) children =
  let open Tyxml.Html in
  let dataset_name = dataset.Sapiens_backend.Dataset.Dataset.name |> Sapiens_backend.Dataset.Dataset.Name.to_string in
  Layout.make
    ~title:title_
    [ Layout.navbar ~user ()
    ; Layout.content
        ([ div
             ~a:[ a_class [ "relative pb-5 border-b border-gray-200 space-y-6 sm:pb-0 mb-5 sm:mb-8" ] ]
             [ div
                 ~a:[ a_class [ "space-y-3 md:flex md:items-center md:justify-between md:space-y-0" ] ]
                 [ h3 ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ] ] [ txt dataset_name ]
                 ; div
                     ~a:[ a_class [ "flex space-x-3 md:absolute md:top-3 md:right-0" ] ]
                     [ span
                         ~a:[ a_class [ "shadow-sm rounded-md" ] ]
                         [ a
                             ~a:
                               [ a_href ("/datasets/" ^ string_of_int dataset.id ^ "/export")
                               ; a_class
                                   [ "inline-flex items-center px-4 py-2 border border-gray-300 text-sm leading-5 \
                                      font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 \
                                      focus:outline-none focus:ring-blue focus:border-blue-300 active:text-gray-800 \
                                      active:bg-gray-50 transition duration-150 ease-in-out"
                                   ]
                               ]
                             [ txt "Export" ]
                         ]
                     ; span
                         ~a:[ a_class [ "shadow-sm rounded-md" ] ]
                         [ a
                             ~a:
                               [ a_href ("/datasets/" ^ string_of_int dataset.id ^ "/settings/sources")
                               ; a_class
                                   [ "inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 \
                                      font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                                      focus:outline-none focus:ring-indigo focus:border-indigo-700 \
                                      active:bg-indigo-700 transition duration-150 ease-in-out"
                                   ]
                               ]
                             [ txt "Import" ]
                         ]
                     ]
                 ]
             ; div
                 [ div
                     ~a:[ a_class [ "sm:hidden" ] ]
                     [ select
                         ~a:
                           [ a_aria "label" [ "Selected tab" ]
                           ; a_class
                               [ "block w-full pl-3 pr-10 py-2 text-base leading-6 border-gray-300 focus:outline-none \
                                  focus:ring-blue focus:border-blue-300 sm:text-sm sm:leading-5 transition ease-in-out \
                                  duration-150"
                               ]
                           ]
                         [ option ~a:[ a_selected () ] (txt "Overview")
                         ; option (txt "Tasks")
                         ; option (txt "Insights")
                         ; option (txt "Settings")
                         ]
                     ]
                 ; div
                     ~a:[ a_class [ "hidden sm:block" ] ]
                     [ nav
                         ~a:[ a_class [ "-mb-px flex space-x-8" ] ]
                         (ListLabels.map nav_items ~f:(fun (var, name, url) ->
                              a
                                ~a:
                                  [ a_href ("/datasets/" ^ string_of_int dataset.id ^ url)
                                  ; a_class
                                      [ (if Some var = active then
                                           "whitespace-nowrap pb-4 px-1 border-b-2 border-indigo-500 font-medium \
                                            text-sm leading-5 text-indigo-600 focus:outline-none focus:text-indigo-800 \
                                            focus:border-indigo-700"
                                        else
                                          "whitespace-nowrap pb-4 px-1 border-b-2 border-transparent font-medium \
                                           text-sm leading-5 text-gray-500 hover:text-gray-700 hover:border-gray-300 \
                                           focus:outline-none focus:text-gray-700 focus:border-gray-300")
                                      ]
                                  ]
                                [ txt name ]))
                     ]
                 ]
             ]
         ]
        @ children)
    ]
