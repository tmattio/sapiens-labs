open Tyxml.Html

module New = struct
  let createElement ?alert () =
    Layout.make
      ~title:"Resend confirmation email · Sapiens"
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
                      [ txt "Resend confirmation email" ]
                  ; p
                      ~a:[ a_class [ "mt-2 text-center text-sm leading-5 text-gray-600" ] ]
                      [ txt "Enter your user account's email address and we will send you a confirmation link." ]
                  ]
              ; (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
              ; form
                  ~a:[ a_class [ "mt-8" ]; a_action "/users/confirm"; a_method `Post ]
                  [ div
                      ~a:[ a_class [ "rounded-md shadow-sm" ] ]
                      [ div
                          [ input
                              ~a:
                                [ a_aria "label" [ "Email address" ]
                                ; a_name "email"
                                ; a_input_type `Email
                                ; a_required ()
                                ; a_class
                                    [ "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md \
                                       shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 \
                                       focus:border-indigo-500 sm:text-sm"
                                    ]
                                ; a_placeholder "Email address"
                                ]
                              ()
                          ]
                      ]
                  ; div
                      ~a:[ a_class [ "mt-6" ] ]
                      [ button
                          ~a:
                            [ a_button_type `Submit
                            ; a_class
                                [ "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm \
                                   text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none \
                                   focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                ]
                            ]
                          [ txt "Send confirmation email" ]
                      ]
                  ]
              ]
          ]
      ]
end

let new_ ?alert () = New.createElement ?alert ()
