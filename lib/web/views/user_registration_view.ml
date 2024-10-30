open Tyxml.Html

let createElement ?alert () =
  Layout.make
    ~title:"Create an account · Sapiens"
    [ div
        ~a:[ a_class [ "min-h-screen bg-white flex" ] ]
        [ div
            ~a:[ a_class [ "flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:flex-none lg:px-20 xl:px-24" ] ]
            [ div
                ~a:[ a_class [ "mx-auto w-full max-w-sm" ] ]
                [ div
                    [ img
                        ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-on-white.svg"
                        ~alt:"Sapiens"
                        ~a:[ a_class [ "h-12 w-auto" ] ]
                        ()
                    ; h2
                        ~a:[ a_class [ "mt-6 text-3xl leading-9 font-extrabold text-gray-900" ] ]
                        [ txt "Create your account" ]
                    ; p
                        ~a:[ a_class [ "mt-2 text-sm leading-5 text-gray-600 max-w" ] ]
                        [ txt "Or "
                        ; a
                            ~a:
                              [ a_href "/users/login"
                              ; a_class
                                  [ "font-medium text-indigo-600 hover:text-indigo-500 focus:outline-none \
                                     focus:underline transition ease-in-out duration-150"
                                  ]
                              ]
                            [ txt "sign in with an existing account" ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "mt-8" ] ]
                [ div
                    ~a:[ a_class [ "mt-6" ] ]
                    [ (match alert with
                      | Some alert ->
                        div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ]
                      | None ->
                        div [])
                    ; form
                        ~a:[ a_action "/users/register"; a_method `Post ]
                        [ div
                            ~a:[ a_class [ "mt-6" ] ]
                            [ label
                                ~a:
                                  [ a_label_for "username"
                                  ; a_class [ "block text-sm font-medium leading-5 text-gray-700" ]
                                  ]
                                [ txt "Username" ]
                            ; div
                                ~a:[ a_class [ "mt-1 rounded-md shadow-sm" ] ]
                                [ input
                                    ~a:
                                      [ a_required ()
                                      ; a_name "username"
                                      ; a_id "username"
                                      ; a_input_type `Text
                                      ; a_class
                                          [ "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md \
                                             shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 \
                                             focus:border-indigo-500 sm:text-sm"
                                          ]
                                      ]
                                    ()
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-6" ] ]
                            [ label
                                ~a:
                                  [ a_label_for "email"
                                  ; a_class [ "block text-sm font-medium leading-5 text-gray-700" ]
                                  ]
                                [ txt "Email address" ]
                            ; div
                                ~a:[ a_class [ "mt-1 rounded-md shadow-sm" ] ]
                                [ input
                                    ~a:
                                      [ a_required ()
                                      ; a_name "email"
                                      ; a_id "email"
                                      ; a_input_type `Email
                                      ; a_class
                                          [ "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md \
                                             shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 \
                                             focus:border-indigo-500 sm:text-sm"
                                          ]
                                      ]
                                    ()
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-6" ] ]
                            [ label
                                ~a:
                                  [ a_label_for "password"
                                  ; a_class [ "block text-sm font-medium leading-5 text-gray-700" ]
                                  ]
                                [ txt "Password" ]
                            ; div
                                ~a:[ a_class [ "mt-1 rounded-md shadow-sm" ] ]
                                [ input
                                    ~a:
                                      [ a_required ()
                                      ; a_name "password"
                                      ; a_id "password"
                                      ; a_input_type `Password
                                      ; a_class
                                          [ "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md \
                                             shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 \
                                             focus:border-indigo-500 sm:text-sm"
                                          ]
                                      ]
                                    ()
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-6 flex items-center justify-between" ] ]
                            [ div
                                ~a:[ a_class [ "flex items-center" ] ]
                                [ input
                                    ~a:
                                      [ a_id "user_remember_me"
                                      ; a_name "user_remember_me"
                                      ; a_input_type `Checkbox
                                      ; a_class
                                          [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded" ]
                                      ]
                                    ()
                                ; label
                                    ~a:
                                      [ a_label_for "user_remember_me"
                                      ; a_class [ "ml-2 block text-sm leading-5 text-gray-900" ]
                                      ]
                                    [ txt "Remember me" ]
                                ]
                            ; div
                                ~a:[ a_class [ "text-sm leading-5" ] ]
                                [ a
                                    ~a:
                                      [ a_href "/users/reset_password"
                                      ; a_class
                                          [ "font-medium text-indigo-600 hover:text-indigo-500 focus:outline-none \
                                             focus:underline transition ease-in-out duration-150"
                                          ]
                                      ]
                                    [ txt "Forgot your password?" ]
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-6" ] ]
                            [ span
                                ~a:[ a_class [ "block w-full rounded-md shadow-sm" ] ]
                                [ button
                                    ~a:
                                      [ a_button_type `Submit
                                      ; a_class
                                          [ "w-full flex justify-center py-2 px-4 border border-transparent rounded-md \
                                             shadow-sm text-sm font-medium text-white bg-indigo-600 \
                                             hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                             focus:ring-indigo-500"
                                          ]
                                      ]
                                    [ txt "Sign up" ]
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-6" ] ]
                            [ p
                                ~a:[ a_class [ "text-xs leading-5 text-gray-500" ] ]
                                [ txt "By signing up, you agree to our "
                                ; a
                                    ~a:[ a_href "/terms"; a_class [ "font-medium text-gray-900 hover:underline" ] ]
                                    [ txt "Terms" ]
                                ; txt " and "
                                ; a
                                    ~a:[ a_href "/privacy"; a_class [ "font-medium text-gray-900 hover:underline" ] ]
                                    [ txt "Privacy Policy" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ; div
            ~a:[ a_class [ "hidden lg:block relative w-0 flex-1" ] ]
            [ img
                ~src:
                  "https://images.unsplash.com/photo-1505904267569-f02eaeb45a4c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1908&q=80"
                ~alt:""
                ~a:[ a_class [ "absolute inset-0 h-full w-full object-cover" ] ]
                ()
            ]
        ]
    ]

let make ?alert () = createElement ?alert ()
