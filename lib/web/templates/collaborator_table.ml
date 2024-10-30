let make ~dataset (users : Sapiens_backend.Account.User.t list) =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "flex flex-col" ] ]
    [ div
        ~a:[ a_class [ "mt-6" ] ]
        [ div
            ~a:[ a_class [ "-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8" ] ]
            [ div
                ~a:[ a_class [ "py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8" ] ]
                [ div
                    ~a:[ a_class [ "shadow overflow-hidden border-b border-gray-200 sm:rounded-lg" ] ]
                    [ table
                        ~a:[ a_class [ "min-w-full divide-y divide-gray-200 bg-white divide-y divide-gray-200" ] ]
                        ~thead:
                          (thead
                             [ tr
                                 [ th
                                     ~a:
                                       [ a_class
                                           [ "px-6 py-3 bg-gray-50 text-left text-xs leading-4 font-medium \
                                              text-gray-500 uppercase tracking-wider"
                                           ]
                                       ]
                                     [ txt "Name" ]
                                 ; th
                                     ~a:
                                       [ a_class
                                           [ "px-6 py-3 bg-gray-50 text-left text-xs leading-4 font-medium \
                                              text-gray-500 uppercase tracking-wider"
                                           ]
                                       ]
                                     [ txt "Status" ]
                                 ; th
                                     ~a:
                                       [ a_class
                                           [ "px-6 py-3 bg-gray-50 text-left text-xs leading-4 font-medium \
                                              text-gray-500 uppercase tracking-wider"
                                           ]
                                       ]
                                     [ txt "Role" ]
                                 ; th ~a:[ a_class [ "px-6 py-3 bg-gray-50" ] ] []
                                 ]
                             ])
                        (List.map
                           (fun (user : Sapiens_backend.Account.User.t) ->
                             tr
                               [ td
                                   ~a:[ a_class [ "px-6 py-4 whitespace-nowrap" ] ]
                                   [ div
                                       ~a:[ a_class [ "items-center" ] ]
                                       [ div
                                           ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-900" ] ]
                                           [ txt (Sapiens_backend.Account.User.Username.to_string user.username) ]
                                       ; div
                                           ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                           [ txt (Sapiens_backend.Account.User.Email.to_string user.email) ]
                                       ]
                                   ]
                               ; td
                                   ~a:[ a_class [ "px-6 py-4 whitespace-nowrap" ] ]
                                   [ span
                                       ~a:
                                         [ a_class
                                             [ "px-2 inline-flex text-xs leading-5 font-semibold rounded-full \
                                                bg-green-100 text-green-800"
                                             ]
                                         ]
                                       [ txt "Active" ]
                                   ]
                               ; td
                                   ~a:[ a_class [ "px-6 py-4 whitespace-nowrap text-sm leading-5 text-gray-500" ] ]
                                   [ txt "Admin" ]
                               ; td
                                   ~a:
                                     [ a_class
                                         [ "px-6 py-4 whitespace-nowrap text-right text-sm leading-5 font-medium" ]
                                     ]
                                   [ form
                                       ~a:
                                         [ a_action
                                             ("/datasets/"
                                             ^ string_of_int dataset.Sapiens_backend.Dataset.Dataset.id
                                             ^ "/removed_collaborator")
                                         ; a_method `Post
                                         ]
                                       [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "DELETE" ] ()
                                       ; input
                                           ~a:
                                             [ a_id "email"
                                             ; a_name "email"
                                             ; a_input_type `Hidden
                                             ; a_value (Sapiens_backend.Account.User.Email.to_string user.email)
                                             ]
                                           ()
                                       ; button
                                           ~a:
                                             [ a_button_type `Submit
                                             ; a_class [ "text-indigo-600 hover:text-indigo-900" ]
                                             ]
                                           [ txt "Remove" ]
                                       ]
                                   ]
                               ])
                           users)
                    ]
                ]
            ]
        ]
    ]
