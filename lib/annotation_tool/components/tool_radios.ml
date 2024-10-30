let make ~title:title_ ~classes ~on_change value =
  let open Tyxml.Html in
  div
    [ div
        ~a:[ a_class [ "pt-2" ] ]
        ([ div
             ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
             [ txt title_ ]
         ]
        @ List.mapi
            (fun i el ->
              div
                ~a:
                  [ a_class
                      [ "mt-4 first:mt-0 chil flex items-center border px-2 \
                         py-2 mr-3 rounded-md relative"
                      ]
                  ]
                [ input
                    ~a:
                      ([ a_class
                           [ "focus:ring-indigo-500 h-6 w-6 text-indigo-600 \
                              border-gray-300"
                           ]
                       ; a_id (title_ ^ "-" ^ string_of_int i)
                       ; a_name (title_ ^ "-" ^ string_of_int i)
                       ; a_input_type `Radio
                       ; a_onchange (fun _ ->
                             on_change el;
                             false)
                       ]
                      @
                      match value with
                      | Some value when String.equal value el ->
                        [ a_checked () ]
                      | _ ->
                        [])
                    ()
                ; label
                    ~a:
                      [ a_label_for (title_ ^ "-" ^ string_of_int i)
                      ; a_class [ "ml-5" ]
                      ]
                    [ span
                        ~a:
                          [ a_class
                              [ "block text-md leading-5 font-medium \
                                 text-gray-700"
                              ]
                          ]
                        [ txt el ]
                    ]
                ; div
                    ~a:[ a_class [ "absolute right-0 -mr-4" ] ]
                    [ span
                        ~a:
                          [ a_class
                              [ "inline-flex items-center px-3 py-0.5 \
                                 rounded-full text-sm font-medium leading-5 \
                                 border bg-white text-gray-800"
                              ]
                          ]
                        [ txt (string_of_int (i + 1)) ]
                    ]
                ])
            classes)
    ]
