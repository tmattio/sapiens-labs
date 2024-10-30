open Tyxml.Html

module Lock_icon = struct
  let createElement () =
    svg
      ~a:
        [ Tyxml.Svg.a_class [ "h-5"; "w-5" ]
        ; Tyxml.Svg.a_fill `CurrentColor
        ; Tyxml.Svg.a_stroke `CurrentColor
        ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
        ]
      [ Tyxml.Svg.path
          ~a:
            [ Tyxml.Xml.string_attrib "fill-rule" "evenodd" |> Tyxml.Svg.to_attrib
            ; Tyxml.Svg.a_d
                "M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
            ; Tyxml.Xml.string_attrib "clip-rule" "evenodd" |> Tyxml.Svg.to_attrib
            ]
          []
      ]
end

let lock_icon = Lock_icon.createElement ()

let createElement ?alert () =
  Layout.make
    ~title:"Sign in to Sapiens · Sapiens"
    [ div
        ~a:[ a_class [ "min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "max-w-md w-full" ] ]
            [ div
                [ img
                    ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-on-white.svg"
                    ~alt:"Sapiens"
                    ~a:[ a_class [ "mx-auto h-12 w-auto" ] ]
                    ()
                ; h2
                    ~a:[ a_class [ "mt-6 text-center text-3xl leading-9 font-extrabold text-gray-900" ] ]
                    [ txt "Sign in to your account" ]
                ; p
                    ~a:[ a_class [ "mt-2 text-center text-sm leading-5 text-gray-600" ] ]
                    [ txt "Or "
                    ; a
                        ~a:
                          [ a_class
                              [ "font-medium text-indigo-600 hover:text-indigo-500 focus:outline-none focus:underline \
                                 transition ease-in-out duration-150"
                              ]
                          ; a_href "/users/register"
                          ]
                        [ txt "create an account" ]
                    ]
                ]
            ; (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
            ; form
                ~a:[ a_class [ "mt-8" ]; a_action "/users/login"; a_method `Post ]
                [ input ~a:[ a_input_type `Hidden; a_name "remember"; a_value "true" ] ()
                ; div
                    ~a:[ a_class [ "rounded-md shadow-sm" ] ]
                    [ div
                        [ input
                            ~a:
                              [ a_aria "label" [ "Email address" ]
                              ; a_name "email"
                              ; a_input_type `Email
                              ; a_required ()
                              ; a_class
                                  [ "appearance-none rounded-none relative block w-full px-3 py-2 border \
                                     border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md \
                                     focus:outline-none focus:ring-blue focus:border-blue-300 focus:z-10 sm:text-sm \
                                     sm:leading-5"
                                  ]
                              ; a_placeholder "Email address"
                              ]
                            ()
                        ]
                    ; div
                        ~a:[ a_class [ "-mt-px" ] ]
                        [ input
                            ~a:
                              [ a_aria "label" [ "Password" ]
                              ; a_name "password"
                              ; a_input_type `Password
                              ; a_required ()
                              ; a_class
                                  [ "appearance-none rounded-none relative block w-full px-3 py-2 border \
                                     border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md \
                                     focus:outline-none focus:ring-blue focus:border-blue-300 focus:z-10 sm:text-sm \
                                     sm:leading-5"
                                  ]
                              ; a_placeholder "Password"
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
                              ; a_class [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded" ]
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
                    [ button
                        ~a:
                          [ a_button_type `Submit
                          ; a_class
                              [ "group relative w-full flex justify-center py-2 px-4 border border-transparent \
                                 rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                              ]
                          ]
                        [ span
                            ~a:[ a_class [ "absolute left-0 inset-y-0 flex items-center pl-3" ] ]
                            [ i
                                ~a:
                                  [ a_class
                                      [ "text-indigo-500 group-hover:text-indigo-400 transition ease-in-out \
                                         duration-150"
                                      ]
                                  ]
                                [ lock_icon ]
                            ]
                        ; txt "Sign in"
                        ]
                    ]
                ]
            ]
        ]
    ]

let make ?alert () = createElement ?alert ()
