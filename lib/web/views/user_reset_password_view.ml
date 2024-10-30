open Tyxml.Html

module Edit = struct
  let createElement ?alert ~token () =
    Layout.make
      ~title:"Reset your password · Sapiens"
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
                      [ txt "Reset your password" ]
                  ; p
                      ~a:[ a_class [ "mt-2 text-center text-sm leading-5 text-gray-600" ] ]
                      [ txt "After you've reset your password, you will be redirected to the login screen." ]
                  ]
              ; (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
              ; form
                  ~a:[ a_class [ "mt-8" ]; a_action ("/users/reset_password/" ^ token); a_method `Post ]
                  [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "PUT" ] ()
                  ; div
                      ~a:[ a_class [ "rounded-md shadow-sm" ] ]
                      [ Input.make
                          ~id:"password"
                          ~name:"password"
                          ~label:"Password"
                          ~placeholder:"************"
                          ~type_:`Password
                          ~required:true
                          ()
                      ]
                  ; div
                      ~a:[ a_class [ "mt-6 rounded-md shadow-sm" ] ]
                      [ Input.make
                          ~id:"password-confirmation"
                          ~name:"password_confirmation"
                          ~label:"Password confirmation"
                          ~placeholder:"************"
                          ~type_:`Password
                          ~required:true
                          ()
                      ]
                  ; div
                      ~a:[ a_class [ "mt-6" ] ]
                      [ button
                          ~a:
                            [ a_button_type `Submit
                            ; a_class
                                [ "group relative w-full flex justify-center py-2 px-4 border border-transparent \
                                   rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 \
                                   hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                   focus:ring-indigo-500"
                                ]
                            ]
                          [ txt "Reset password" ]
                      ]
                  ]
              ]
          ]
      ]
end

let edit ?alert ~token () = Edit.createElement ?alert ~token ()

module New = struct
  let createElement ?alert () =
    Layout.make
      ~title:"Forgot your password? · Sapiens"
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
                      [ txt "Forgot your password?" ]
                  ; p
                      ~a:[ a_class [ "mt-2 text-center text-sm leading-5 text-gray-600" ] ]
                      [ txt
                          "Enter your user account's verified email address and we will send you a password reset link."
                      ]
                  ]
              ; (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
              ; form
                  ~a:[ a_class [ "mt-8" ]; a_action "/users/reset_password"; a_method `Post ]
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
                                [ "group relative w-full flex justify-center py-2 px-4 border border-transparent \
                                   rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 \
                                   hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                   focus:ring-indigo-500"
                                ]
                            ]
                          [ txt "Send password reset email" ]
                      ]
                  ]
              ]
          ]
      ]
end

let new_ ?alert () = New.createElement ?alert ()
