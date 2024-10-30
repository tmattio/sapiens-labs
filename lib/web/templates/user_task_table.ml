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
                             [ txt "Progress" ]
                         ; th ~a:[ a_class [ "px-6 py-3 border-b border-gray-200 bg-gray-50" ] ] []
                         ]
                     ])
                (List.map
                   (fun (task : Sapiens_backend.Annotation.Task.t) ->
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
                                 ~percentage:
                                   (List.assoc task.id progress_
                                   |> Sapiens_backend.Annotation.Progress.compute
                                   |> ( *. ) 100.
                                   |> int_of_float)
                                 ~color:`green
                                 ()
                             | Canceled ->
                               (* This should never happen *)
                               div []
                             | Completed ->
                               (* This should never happen *)
                               div [])
                           ]
                       ; td
                           ~a:
                             [ a_class
                                 [ "px-6 py-4 whitespace-nowrap text-right border-b border-gray-200 text-sm leading-5 \
                                    font-medium"
                                 ]
                             ]
                           [ a
                               ~a:
                                 [ a_href ("/tasks/" ^ string_of_int task.id)
                                 ; a_class [ "text-indigo-600 hover:text-indigo-900" ]
                                 ]
                               [ txt "Annotate" ]
                           ]
                       ])
                   tasks)
            ]
        ]
    ]
