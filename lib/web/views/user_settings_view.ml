open Tyxml.Html

module Modal = struct
  let createElement ~children () =
    let open Tyxml.Html in
    let a_custom x y = Xml.string_attrib x y |> to_attrib in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    div
      ~a:[ a_custom "x-data" "{ open: false }"; a_custom "@keydown.escape" "open = false" ]
      ([ div
           ~a:
             [ a_custom "x-show" "open"
             ; a_class
                 [ "fixed bottom-0 inset-x-0 px-4 pb-6 sm:inset-0 sm:p-0 sm:flex sm:items-center sm:justify-center" ]
             ]
           [ div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Background overlay, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0"
                 ; a_custom "x-transition:enter-end" "opacity-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100"
                 ; a_custom "x-transition:leave-end" "opacity-0"
                 ; a_class [ "fixed inset-0 transition-opacity" ]
                 ]
               [ div ~a:[ a_class [ "absolute inset-0 bg-gray-500 opacity-75" ] ] [] ]
           ; div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Modal panel, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_custom "x-transition:enter-end" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave-end" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_class
                     [ "bg-white rounded-lg px-4 pt-5 pb-4 overflow-hidden shadow-xl transform transition-all \
                        sm:max-w-lg sm:w-full sm:p-6"
                     ]
                 ; a_role [ "dialog" ]
                 ; a_aria "modal" [ "true" ]
                 ; a_aria "labelledby" [ "modal-headline" ]
                 ; a_custom "@click.away" "open = false"
                 ]
               [ div
                   [ div
                       ~a:[ a_class [ "mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100" ] ]
                       [ svg
                           ~a:
                             [ Tyxml.Svg.a_class [ "h-6 w-6 text-red-600" ]
                             ; Tyxml.Svg.a_fill `None
                             ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                             ; Tyxml.Svg.a_stroke `CurrentColor
                             ]
                           [ Tyxml.Svg.path
                               ~a:
                                 [ a_svg_custom "stroke-linecap" "round"
                                 ; a_svg_custom "stroke-linejoin" "round"
                                 ; a_svg_custom "stroke-width" "2"
                                 ; Tyxml.Svg.a_d
                                     "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 \
                                      4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                 ]
                               []
                           ]
                       ]
                   ; div
                       ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                       [ h3
                           ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                           [ txt "Are you sure?" ]
                       ; div
                           ~a:[ a_class [ "mt-2" ] ]
                           [ p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt "We will "; b [ txt "immediately delete all of your datasets." ] ]
                           ; p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt " You will no longer be billed, and your username will be available to anyone." ]
                           ]
                       ]
                   ]
               ; form
                   ~a:[ a_action "/users/settings/deleted_account"; a_method `Post ]
                   [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "DELETE" ] ()
                   ; div
                       ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
                       [ Input.make
                           ~id:"password"
                           ~name:"password"
                           ~label:"Confirm your password"
                           ~placeholder:"************"
                           ~type_:`Password
                           ~required:true
                           ()
                       ]
                   ; div
                       ~a:[ a_class [ "mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense" ] ]
                       [ span
                           ~a:[ a_class [ "flex w-full rounded-md shadow-sm sm:col-start-2" ] ]
                           [ button
                               ~a:
                                 [ a_button_type `Submit
                                 ; a_class
                                     [ "inline-flex justify-center w-full flex justify-center py-2 px-4 border \
                                        border-transparent rounded-md shadow-sm text-sm font-medium text-white \
                                        bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-red-500"
                                     ]
                                 ]
                               [ txt "Delete my account" ]
                           ]
                       ; span
                           ~a:[ a_class [ "mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:col-start-1" ] ]
                           [ button
                               ~a:
                                 [ a_custom "@click" "open = false"
                                 ; a_button_type `Button
                                 ; a_class
                                     [ "inline-flex justify-center w-full flex justify-center py-2 px-4 border \
                                        border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 \
                                        bg-white hover:text-gray-500 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-blue-500"
                                     ]
                                 ]
                               [ txt "Cancel" ]
                           ]
                       ]
                   ]
               ]
           ]
       ]
      @ children)
end

let modal children = Modal.createElement ~children ()

let createElement ?alert ~user () =
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  Layout.make
    ~title:"Account settings · Sapiens"
    [ Layout.navbar ~user ()
    ; Layout.page_title ~title:"Account settings" ()
    ; Layout.content
        [ div
            [ div
                ~a:[ a_class [ "mt-10 sm:mt-0" ] ]
                [ (match alert with
                  | Some alert ->
                    div ~a:[ a_class [ "mb-10" ] ] [ Alert.make alert ]
                  | None ->
                    div [])
                ; div
                    ~a:[ a_class [ "md:grid md:grid-cols-3 md:gap-6" ] ]
                    [ div
                        ~a:[ a_class [ "md:col-span-1" ] ]
                        [ div
                            ~a:[ a_class [ "px-4 sm:px-0" ] ]
                            [ h3 ~a:[ a_class [ "text-lg font-medium leading-6 text-gray-900" ] ] [ txt "Password" ]
                            ; p
                                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-600" ] ]
                                [ txt "Make sure it's at least 12 characters." ]
                            ; p
                                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-600" ] ]
                                [ txt
                                    "If you forgot your password, you can log out and reset your password from the \
                                     login screen."
                                ]
                            ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-5 md:mt-0 md:col-span-2" ] ]
                        [ form
                            ~a:[ a_action "/users/settings/updated_password"; a_method `Post ]
                            [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "PUT" ] ()
                            ; Panel.make
                                [ Panel.body
                                    [ div
                                        ~a:[ a_class [ "grid grid-cols-3 gap-6" ] ]
                                        [ div
                                            ~a:[ a_class [ "col-span-3 sm:col-span-2" ] ]
                                            [ Input.make
                                                ~id:"current-password"
                                                ~name:"current_password"
                                                ~label:"Current password"
                                                ~placeholder:"************"
                                                ~type_:`Password
                                                ~required:true
                                                ()
                                            ]
                                        ]
                                    ; div
                                        ~a:[ a_class [ "mt-6" ] ]
                                        [ div
                                            ~a:[ a_class [ "grid grid-cols-3 gap-6" ] ]
                                            [ div
                                                ~a:[ a_class [ "col-span-3 sm:col-span-2" ] ]
                                                [ Input.make
                                                    ~id:"new-password"
                                                    ~name:"new_password"
                                                    ~label:"New password"
                                                    ~placeholder:"************"
                                                    ~type_:`Password
                                                    ~required:true
                                                    ()
                                                ]
                                            ]
                                        ]
                                    ]
                                ; Panel.footer
                                    ~gray:true
                                    [ div
                                        ~a:[ a_class [ "text-right" ] ]
                                        [ button
                                            ~a:
                                              [ a_button_type `Submit
                                              ; a_class
                                                  [ "py-2 px-4 border border-transparent rounded-md shadow-sm text-sm \
                                                     font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                                     focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                                     focus:ring-indigo-500"
                                                  ]
                                              ]
                                            [ txt "Update password" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "hidden sm:block" ] ]
                [ div ~a:[ a_class [ "py-5" ] ] [ div ~a:[ a_class [ "border-t border-gray-200" ] ] [] ] ]
            ; div
                ~a:[ a_class [ "mt-10 sm:mt-0" ] ]
                [ div
                    ~a:[ a_class [ "md:grid md:grid-cols-3 md:gap-6" ] ]
                    [ div
                        ~a:[ a_class [ "md:col-span-1" ] ]
                        [ div
                            ~a:[ a_class [ "px-4 sm:px-0" ] ]
                            [ h3 ~a:[ a_class [ "text-lg font-medium leading-6 text-gray-900" ] ] [ txt "Email" ]
                            ; p
                                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-600" ] ]
                                [ txt "A confirmation email will be sent to the new address." ]
                            ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-5 md:mt-0 md:col-span-2" ] ]
                        [ form
                            ~a:[ a_action "/users/settings/updated_email"; a_method `Post ]
                            [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "PUT" ] ()
                            ; Panel.make
                                [ Panel.body
                                    [ div
                                        ~a:[ a_class [ "grid grid-cols-3 gap-6" ] ]
                                        [ div
                                            ~a:[ a_class [ "col-span-3 sm:col-span-2" ] ]
                                            [ Input.make
                                                ~id:"current-password"
                                                ~name:"current_password"
                                                ~label:"Current password"
                                                ~placeholder:"************"
                                                ~type_:`Password
                                                ~required:true
                                                ()
                                            ]
                                        ]
                                    ; div
                                        ~a:[ a_class [ "mt-6" ] ]
                                        [ div
                                            ~a:[ a_class [ "grid grid-cols-3 gap-6" ] ]
                                            [ div
                                                ~a:[ a_class [ "col-span-3 sm:col-span-2" ] ]
                                                [ Input.make
                                                    ~id:"email"
                                                    ~name:"email"
                                                    ~label:"New email"
                                                    ~placeholder:"you@example.com"
                                                    ~type_:`Email
                                                    ~required:true
                                                    ()
                                                ]
                                            ]
                                        ]
                                    ]
                                ; Panel.footer
                                    ~gray:true
                                    [ div
                                        ~a:[ a_class [ "text-right" ] ]
                                        [ button
                                            ~a:
                                              [ a_button_type `Submit
                                              ; a_class
                                                  [ "py-2 px-4 border border-transparent rounded-md shadow-sm text-sm \
                                                     font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                                     focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                                     focus:ring-indigo-500"
                                                  ]
                                              ]
                                            [ txt "Update email" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "hidden sm:block" ] ]
                [ div ~a:[ a_class [ "py-5" ] ] [ div ~a:[ a_class [ "border-t border-gray-200" ] ] [] ] ]
            ; div
                ~a:[ a_class [ "mt-10 sm:mt-0" ] ]
                [ div
                    ~a:[ a_class [ "md:grid md:grid-cols-3 md:gap-6" ] ]
                    [ div
                        ~a:[ a_class [ "md:col-span-1" ] ]
                        [ div
                            ~a:[ a_class [ "px-4 sm:px-0" ] ]
                            [ h3 ~a:[ a_class [ "text-lg font-medium leading-6 text-red-600" ] ] [ txt "Danger zone" ]
                            ; p
                                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-600" ] ]
                                [ txt "Make sure you know what you're doing!" ]
                            ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-5 md:mt-0 md:col-span-2" ] ]
                        [ Panel.make
                            [ Panel.body
                                [ h3
                                    ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Delete your account" ]
                                ; div
                                    ~a:[ a_class [ "mt-2 max-w-xl text-sm leading-5 text-gray-500" ] ]
                                    [ p
                                        [ txt "Once you delete your account, you will lose all data associated with it."
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "mt-5" ] ]
                                    [ modal
                                        [ button
                                            ~a:
                                              [ a_custom "@click" "open = true"
                                              ; a_button_type `Button
                                              ; a_class
                                                  [ "inline-flex items-center justify-center py-2 px-4 border \
                                                     border-transparent rounded-md shadow-sm text-sm font-medium \
                                                     text-red-700 bg-red-100 hover:bg-red-700 focus:outline-none \
                                                     focus:ring-2 focus:ring-offset-2 focus:ring-red-300"
                                                  ]
                                              ]
                                            [ txt "Delete account" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let make ?alert ~user () = createElement ?alert ~user ()
