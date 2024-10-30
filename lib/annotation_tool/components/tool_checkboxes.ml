let make ~title:title_ ~classes ?min_count:_ ?max_count ~on_change value =
  let open Tyxml.Html in
  let max_count = Option.value max_count ~default:(List.length classes) in
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
                              border-gray-300 rounded"
                           ]
                       ; a_id (title_ ^ "-" ^ string_of_int i)
                       ; a_name (title_ ^ "-" ^ string_of_int i)
                       ; a_input_type `Checkbox
                       ; a_onchange (fun _ ->
                             let new_value =
                               match List.mem el value with
                               | true ->
                                 List.filter
                                   (fun x -> not (String.equal el x))
                                   value
                               | false when List.length value < max_count ->
                                 el :: value
                               | false ->
                                 value
                             in
                             on_change new_value;
                             false)
                       ]
                      @
                      match List.mem el value with
                      | true ->
                        [ a_checked () ]
                      | false ->
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
