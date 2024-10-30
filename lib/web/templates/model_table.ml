let make _models =
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
                             [ txt "Title" ]
                         ; th
                             ~a:
                               [ a_class
                                   [ "px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 \
                                      font-medium text-gray-500 uppercase tracking-wider"
                                   ]
                               ]
                             [ txt "Status" ]
                         ; th
                             ~a:
                               [ a_class
                                   [ "px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 \
                                      font-medium text-gray-500 uppercase tracking-wider"
                                   ]
                               ]
                             [ txt "Role" ]
                         ; th ~a:[ a_class [ "px-6 py-3 border-b border-gray-200 bg-gray-50" ] ] []
                         ]
                     ])
                [ tr
                    [ td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div
                            ~a:[ a_class [ "flex items-center" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0 h-10 w-10" ] ]
                                [ img
                                    ~src:
                                      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    ~alt:""
                                    ~a:[ a_class [ "h-10 w-10 rounded-full" ] ]
                                    ()
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ div
                                    ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-900" ] ]
                                    [ txt "Bernard Lane" ]
                                ; div
                                    ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                    [ txt "bernardlane@example.com" ]
                                ]
                            ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div ~a:[ a_class [ "text-sm leading-5 text-gray-900" ] ] [ txt "Director" ]
                        ; div ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ] [ txt "Human Resources" ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ span
                            ~a:
                              [ a_class
                                  [ "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 \
                                     text-green-800"
                                  ]
                              ]
                            [ txt "Active" ]
                        ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap border-b border-gray-200 text-sm leading-5 text-gray-500" ]
                          ]
                        [ txt "Owner" ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap text-right border-b border-gray-200 text-sm leading-5 \
                                 font-medium"
                              ]
                          ]
                        [ a ~a:[ a_href "#"; a_class [ "text-indigo-600 hover:text-indigo-900" ] ] [ txt "Edit" ] ]
                    ]
                ; tr
                    [ td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div
                            ~a:[ a_class [ "flex items-center" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0 h-10 w-10" ] ]
                                [ img
                                    ~src:
                                      "https://images.unsplash.com/photo-1532910404247-7ee9488d7292?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    ~alt:""
                                    ~a:[ a_class [ "h-10 w-10 rounded-full" ] ]
                                    ()
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ div
                                    ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-900" ] ]
                                    [ txt "Bernard Lane" ]
                                ; div
                                    ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                    [ txt "bernardlane@example.com" ]
                                ]
                            ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div ~a:[ a_class [ "text-sm leading-5 text-gray-900" ] ] [ txt "Director" ]
                        ; div ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ] [ txt "Human Resources" ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ span
                            ~a:
                              [ a_class
                                  [ "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 \
                                     text-green-800"
                                  ]
                              ]
                            [ txt "Active" ]
                        ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap border-b border-gray-200 text-sm leading-5 text-gray-500" ]
                          ]
                        [ txt "Owner" ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap text-right border-b border-gray-200 text-sm leading-5 \
                                 font-medium"
                              ]
                          ]
                        [ a ~a:[ a_href "#"; a_class [ "text-indigo-600 hover:text-indigo-900" ] ] [ txt "Edit" ] ]
                    ]
                ; tr
                    [ td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div
                            ~a:[ a_class [ "flex items-center" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0 h-10 w-10" ] ]
                                [ img
                                    ~src:
                                      "https://images.unsplash.com/photo-1505503693641-1926193e8d57?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    ~alt:""
                                    ~a:[ a_class [ "h-10 w-10 rounded-full" ] ]
                                    ()
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ div
                                    ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-900" ] ]
                                    [ txt "Bernard Lane" ]
                                ; div
                                    ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                    [ txt "bernardlane@example.com" ]
                                ]
                            ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ div ~a:[ a_class [ "text-sm leading-5 text-gray-900" ] ] [ txt "Director" ]
                        ; div ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ] [ txt "Human Resources" ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap border-b border-gray-200" ] ]
                        [ span
                            ~a:
                              [ a_class
                                  [ "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 \
                                     text-red-800"
                                  ]
                              ]
                            [ txt "Inactive" ]
                        ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap border-b border-gray-200 text-sm leading-5 text-gray-500" ]
                          ]
                        [ txt "Owner" ]
                    ; td
                        ~a:
                          [ a_class
                              [ "px-6 py-4 whitespace-nowrap text-right border-b border-gray-200 text-sm leading-5 \
                                 font-medium"
                              ]
                          ]
                        [ a ~a:[ a_href "#"; a_class [ "text-indigo-600 hover:text-indigo-900" ] ] [ txt "Edit" ] ]
                    ]
                ; tr
                    [ td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap" ] ]
                        [ div
                            ~a:[ a_class [ "flex items-center" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0 h-10 w-10" ] ]
                                [ img
                                    ~src:
                                      "https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    ~alt:""
                                    ~a:[ a_class [ "h-10 w-10 rounded-full" ] ]
                                    ()
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ div
                                    ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-900" ] ]
                                    [ txt "Bernard Lane" ]
                                ; div
                                    ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                    [ txt "bernardlane@example.com" ]
                                ]
                            ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap" ] ]
                        [ div ~a:[ a_class [ "text-sm leading-5 text-gray-900" ] ] [ txt "Director" ]
                        ; div ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ] [ txt "Human Resources" ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap" ] ]
                        [ span
                            ~a:
                              [ a_class
                                  [ "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 \
                                     text-red-800"
                                  ]
                              ]
                            [ txt "Inactive" ]
                        ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap text-sm leading-5 text-gray-500" ] ]
                        [ txt "Owner" ]
                    ; td
                        ~a:[ a_class [ "px-6 py-4 whitespace-nowrap text-right text-sm leading-5 font-medium" ] ]
                        [ a ~a:[ a_href "#"; a_class [ "text-indigo-600 hover:text-indigo-900" ] ] [ txt "Edit" ] ]
                    ]
                ]
            ]
        ]
    ]
