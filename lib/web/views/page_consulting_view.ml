let content () =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "py-16 overflow-hidden" ] ]
    [ div
        ~a:[ a_class [ "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "text-base max-w-prose mx-auto lg:max-w-none" ] ]
            [ h1
                ~a:
                  [ a_class
                      [ "mt-2 mb-8 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl \
                         sm:leading-10"
                      ]
                  ]
                [ txt "What makes us different" ]
            ]
        ; div
            ~a:[ a_class [ "relative z-10 text-base max-w-prose mx-auto mb-8 lg:max-w-5xl lg:mx-0 lg:pr-72" ] ]
            [ p
                ~a:[ a_class [ "text-lg text-gray-500 leading-7" ] ]
                [ txt
                    "Sagittis scelerisque nulla cursus in enim consectetur quam. Dictum urna sed consectetur neque \
                     tristique pellentesque. Blandit amet, sed aenean erat arcu morbi. Cursus faucibus nunc nisl netus \
                     morbi vel porttitor vitae ut. Amet vitae fames senectus vitae."
                ]
            ]
        ; div
            ~a:[ a_class [ "lg:grid lg:grid-cols-2 lg:gap-8 lg:items-start" ] ]
            [ div
                ~a:[ a_class [ "relative z-10 mb-12 lg:mb-0" ] ]
                [ div
                    ~a:[ a_class [ "mb-10 prose text-gray-500 mx-auto lg:max-w-none" ] ]
                    [ p
                        [ txt
                            "Sollicitudin tristique eros erat odio sed vitae, consequat turpis elementum. Lorem nibh \
                             vel, eget pretium arcu vitae. Eros eu viverra donec ut volutpat donec laoreet quam urna."
                        ]
                    ; ul
                        [ li [ txt "Quis elit egestas venenatis mattis dignissim." ]
                        ; li [ txt "Cras cras lobortis vitae vivamus ultricies facilisis tempus." ]
                        ; li [ txt "Orci in sit morbi dignissim metus diam arcu pretium." ]
                        ]
                    ; p
                        [ txt
                            "Rhoncus nisl, libero egestas diam fermentum dui. At quis tincidunt vel ultricies. \
                             Vulputate aliquet velit faucibus semper. Pellentesque in venenatis vestibulum consectetur \
                             nibh id. In id ut tempus egestas. Enim sit aliquam nec, a. Morbi enim fermentum lacus in. \
                             Viverra."
                        ]
                    ; h2 [ txt "We\226\128\153re here to help" ]
                    ; p
                        [ txt
                            "Tincidunt integer commodo, cursus etiam aliquam neque, et. Consectetur pretium in \
                             volutpat, diam. Montes, magna cursus nulla feugiat dignissim id lobortis amet. Laoreet \
                             sem est phasellus eu proin massa, lectus. Diam rutrum posuere donec ultricies non morbi. \
                             Mi a platea auctor mi."
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "relative text-base max-w-prose mx-auto lg:max-w-none" ] ]
                [ svg
                    ~a:
                      [ Tyxml.Svg.a_class
                          [ "absolute top-0 right-0 -mt-20 -mr-20 lg:top-auto lg:right-auto lg:bottom-1/2 lg:left-1/2 \
                             lg:mt-0 lg:mr-0 xl:top-0 xl:right-0 xl:-mt-20 xl:-mr-20"
                          ]
                      ; Tyxml.Svg.a_width (404., None)
                      ; Tyxml.Svg.a_height (384., None)
                      ; Tyxml.Svg.a_fill `None
                      ; Tyxml.Svg.a_viewBox (0., 0., 404., 384.)
                      ]
                    [ Tyxml.Svg.defs
                        [ Tyxml.Svg.pattern
                            ~a:
                              [ Tyxml.Svg.a_id "bedc54bc-7371-44a2-a2bc-dc68d819ae60"
                              ; Tyxml.Svg.a_x (0., None)
                              ; Tyxml.Svg.a_y (0., None)
                              ; Tyxml.Svg.a_width (20., None)
                              ; Tyxml.Svg.a_height (20., None)
                              ; Tyxml.Svg.a_patternUnits `UserSpaceOnUse
                              ]
                            [ Tyxml.Svg.rect
                                ~a:
                                  [ Tyxml.Svg.a_x (0., None)
                                  ; Tyxml.Svg.a_y (0., None)
                                  ; Tyxml.Svg.a_width (4., None)
                                  ; Tyxml.Svg.a_height (4., None)
                                  ; Tyxml.Svg.a_class [ "text-gray-200" ]
                                  ; Tyxml.Svg.a_fill `CurrentColor
                                  ]
                                []
                            ]
                        ]
                    ; Tyxml.Svg.rect
                        ~a:
                          [ Tyxml.Svg.a_width (404., None)
                          ; Tyxml.Svg.a_height (384., None)
                          ; Tyxml.Svg.a_fill (`Icc ("#bedc54bc-7371-44a2-a2bc-dc68d819ae60", None))
                          ]
                        []
                    ]
                ; blockquote
                    ~a:[ a_class [ "relative bg-white rounded-lg shadow-lg" ] ]
                    [ div
                        ~a:[ a_class [ "rounded-t-lg px-6 py-8 sm:px-10 sm:pt-10 sm:pb-8" ] ]
                        [ img
                            ~src:"https://tailwindui.com/img/logos/v1/workcation-color.svg"
                            ~alt:"Workcation"
                            ~a:[ a_class [ "h-8" ] ]
                            ()
                        ; div
                            ~a:[ a_class [ "relative text-lg text-gray-700 leading-7 font-medium mt-8" ] ]
                            [ svg
                                ~a:
                                  [ Tyxml.Svg.a_class
                                      [ "absolute top-0 left-0 transform -translate-x-3 -translate-y-2 h-8 w-8 \
                                         text-gray-200"
                                      ]
                                  ; Tyxml.Svg.a_fill `CurrentColor
                                  ; Tyxml.Svg.a_viewBox (0., 0., 32., 32.)
                                  ]
                                [ Tyxml.Svg.path
                                    ~a:
                                      [ Tyxml.Svg.a_d
                                          "M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 \
                                           5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 \
                                           0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 \
                                           0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 \
                                           5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 \
                                           0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z"
                                      ]
                                    []
                                ]
                            ; p
                                ~a:[ a_class [ "relative" ] ]
                                [ txt
                                    "Tincidunt integer commodo, cursus etiam aliquam neque, et. Consectetur pretium in \
                                     volutpat, diam. Montes, magna cursus nulla feugiat dignissim id lobortis amet. \
                                     Laoreet sem est phasellus eu proin massa, lectus."
                                ]
                            ]
                        ]
                    ; cite
                        ~a:
                          [ a_class
                              [ "flex items-center sm:items-start bg-indigo-600 rounded-b-lg not-italic py-5 px-6 \
                                 sm:py-5 sm:pl-12 sm:pr-10 sm:mt-10"
                              ]
                          ]
                        [ span
                            ~a:[ a_class [ "block rounded-full border-2 border-white mr-4 sm:-mt-15 sm:mr-6" ] ]
                            [ img
                                ~src:
                                  "https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?ixlib=rb-1.2.1&auto=format&fit=facearea&facepad=2.5&w=160&h=160&q=80"
                                ~alt:""
                                ~a:[ a_class [ "w-12 h-12 sm:w-20 sm:h-20 rounded-full bg-indigo-300" ] ]
                                ()
                            ]
                        ; span
                            ~a:[ a_class [ "text-indigo-300 font-semibold leading-6" ] ]
                            [ strong ~a:[ a_class [ "text-white font-semibold" ] ] [ txt "Judith Black" ]
                            ; br ~a:[ a_class [ "sm:hidden" ] ] ()
                            ; txt " CEO at Workcation"
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let contact_form () =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "bg-white py-16 px-4 overflow-hidden sm:px-6 lg:px-8 lg:py-24" ] ]
    [ div
        ~a:[ a_class [ "relative max-w-xl mx-auto" ] ]
        [ svg
            ~a:
              [ Tyxml.Svg.a_class [ "absolute left-full transform translate-x-1/2" ]
              ; Tyxml.Svg.a_width (404., None)
              ; Tyxml.Svg.a_height (404., None)
              ; Tyxml.Svg.a_fill `None
              ; Tyxml.Svg.a_viewBox (0., 0., 404., 404.)
              ]
            [ Tyxml.Svg.defs
                [ Tyxml.Svg.pattern
                    ~a:
                      [ Tyxml.Svg.a_id "85737c0e-0916-41d7-917f-596dc7edfa27"
                      ; Tyxml.Svg.a_x (0., None)
                      ; Tyxml.Svg.a_y (0., None)
                      ; Tyxml.Svg.a_width (20., None)
                      ; Tyxml.Svg.a_height (20., None)
                      ; Tyxml.Svg.a_patternUnits `UserSpaceOnUse
                      ]
                    [ Tyxml.Svg.rect
                        ~a:
                          [ Tyxml.Svg.a_x (0., None)
                          ; Tyxml.Svg.a_y (0., None)
                          ; Tyxml.Svg.a_width (4., None)
                          ; Tyxml.Svg.a_height (4., None)
                          ; Tyxml.Svg.a_class [ "text-gray-200" ]
                          ; Tyxml.Svg.a_fill `CurrentColor
                          ]
                        []
                    ]
                ]
            ; Tyxml.Svg.rect
                ~a:
                  [ Tyxml.Svg.a_width (404., None)
                  ; Tyxml.Svg.a_height (404., None)
                  ; Tyxml.Svg.a_fill (`Icc ("#85737c0e-0916-41d7-917f-596dc7edfa27", None))
                  ]
                []
            ]
        ; svg
            ~a:
              [ Tyxml.Svg.a_class [ "absolute right-full bottom-0 transform -translate-x-1/2" ]
              ; Tyxml.Svg.a_width (404., None)
              ; Tyxml.Svg.a_height (404., None)
              ; Tyxml.Svg.a_fill `None
              ; Tyxml.Svg.a_viewBox (0., 0., 404., 404.)
              ]
            [ Tyxml.Svg.defs
                [ Tyxml.Svg.pattern
                    ~a:
                      [ Tyxml.Svg.a_id "85737c0e-0916-41d7-917f-596dc7edfa27"
                      ; Tyxml.Svg.a_x (0., None)
                      ; Tyxml.Svg.a_y (0., None)
                      ; Tyxml.Svg.a_width (20., None)
                      ; Tyxml.Svg.a_height (20., None)
                      ; Tyxml.Svg.a_patternUnits `UserSpaceOnUse
                      ]
                    [ Tyxml.Svg.rect
                        ~a:
                          [ Tyxml.Svg.a_x (0., None)
                          ; Tyxml.Svg.a_y (0., None)
                          ; Tyxml.Svg.a_width (4., None)
                          ; Tyxml.Svg.a_height (4., None)
                          ; Tyxml.Svg.a_class [ "text-gray-200" ]
                          ; Tyxml.Svg.a_fill `CurrentColor
                          ]
                        []
                    ]
                ]
            ; Tyxml.Svg.rect
                ~a:
                  [ Tyxml.Svg.a_width (404., None)
                  ; Tyxml.Svg.a_height (404., None)
                  ; Tyxml.Svg.a_fill (`Icc ("#85737c0e-0916-41d7-917f-596dc7edfa27", None))
                  ]
                []
            ]
        ; div
            ~a:[ a_class [ "text-center" ] ]
            [ h2
                ~a:
                  [ a_class
                      [ "text-3xl leading-9 font-extrabold tracking-tight text-gray-900 sm:text-4xl sm:leading-10" ]
                  ]
                [ txt "Contact us" ]
            ; p
                ~a:[ a_class [ "mt-4 text-lg leading-6 text-gray-500" ] ]
                [ txt
                    "Nullam risus blandit ac aliquam justo ipsum. Quam mauris volutpat massa dictumst amet. Sapien \
                     tortor lacus arcu."
                ]
            ]
        ; div
            ~a:[ a_class [ "mt-12" ] ]
            [ form
                ~a:[ a_action "#"; a_method `Post; a_class [ "grid grid-cols-1 gap-y-6 sm:grid-cols-2 sm:gap-x-8" ] ]
                [ div
                    [ label
                        ~a:[ a_label_for "first_name"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                        [ txt "First name" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ input
                            ~a:
                              [ a_id "first_name"
                              ; a_input_type `Text
                              ; a_class
                                  [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ]
                            ()
                        ]
                    ]
                ; div
                    [ label
                        ~a:[ a_label_for "last_name"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                        [ txt "Last name" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ input
                            ~a:
                              [ a_id "last_name"
                              ; a_input_type `Text
                              ; a_class
                                  [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ]
                            ()
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ label
                        ~a:[ a_label_for "company"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                        [ txt "Company" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ input
                            ~a:
                              [ a_id "company"
                              ; a_input_type `Text
                              ; a_class
                                  [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ]
                            ()
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ label
                        ~a:[ a_label_for "email"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                        [ txt "Email" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ input
                            ~a:
                              [ a_id "email"
                              ; a_input_type `Email
                              ; a_class
                                  [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ]
                            ()
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ label
                        ~a:
                          [ a_label_for "phone_number"
                          ; a_class [ "block text-sm font-medium leading-5 text-gray-700" ]
                          ]
                        [ txt "Phone Number" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ div
                            ~a:[ a_class [ "absolute inset-y-0 left-0 flex items-center" ] ]
                            [ select
                                ~a:
                                  [ a_aria "label" [ "Country" ]
                                  ; a_class
                                      [ "h-full py-0 pl-4 pr-8 border-transparent bg-transparent text-gray-500 \
                                         focus:ring-indigo-500 focus:border-indigo-500 rounded-md"
                                      ]
                                  ]
                                [ option (txt "US"); option (txt "CA"); option (txt "EU") ]
                            ]
                        ; input
                            ~a:
                              [ a_id "phone_number"
                              ; a_input_type `Text
                              ; a_class
                                  [ "py-3 px-4 block w-full pl-20 focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ; a_placeholder "+1 (555) 987-6543"
                              ]
                            ()
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ label
                        ~a:[ a_label_for "message"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                        [ txt "Message" ]
                    ; div
                        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
                        [ textarea
                            ~a:
                              [ a_id "message"
                              ; a_rows 4
                              ; a_class
                                  [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 \
                                     border-gray-300 rounded-md"
                                  ]
                              ]
                            (txt "")
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ div
                        ~a:[ a_class [ "flex items-start" ] ]
                        [ div
                            ~a:[ a_class [ "flex-shrink-0" ] ]
                            [ span
                                ~a:
                                  [ a_role [ "checkbox" ]
                                  ; a_tabindex 0
                                  ; a_aria "checked" [ "false" ]
                                  ; a_class
                                      [ "bg-gray-200 relative inline-flex flex-shrink-0 h-6 w-11 border-2 \
                                         border-transparent rounded-full cursor-pointer transition-colors ease-in-out \
                                         duration-200 focus:outline-none focus:ring"
                                      ]
                                  ]
                                [ span
                                    ~a:
                                      [ a_aria "hidden" [ "true" ]
                                      ; a_class
                                          [ "translate-x-0 inline-block h-5 w-5 rounded-full bg-white shadow transform \
                                             transition ease-in-out duration-200"
                                          ]
                                      ]
                                    []
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "ml-3" ] ]
                            [ p
                                ~a:[ a_class [ "text-base leading-6 text-gray-500" ] ]
                                [ txt "By selecting this, you agree to the "
                                ; a
                                    ~a:[ a_href "#"; a_class [ "font-medium text-gray-700 underline" ] ]
                                    [ txt "Privacy Policy" ]
                                ; txt " and "
                                ; a
                                    ~a:[ a_href "#"; a_class [ "font-medium text-gray-700 underline" ] ]
                                    [ txt "Cookie Policy" ]
                                ; txt "."
                                ]
                            ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "sm:col-span-2" ] ]
                    [ span
                        ~a:[ a_class [ "w-full inline-flex rounded-md shadow-sm" ] ]
                        [ button
                            ~a:
                              [ a_button_type `Button
                              ; a_class
                                  [ "w-full inline-flex items-center justify-center px-6 py-3 border \
                                     border-transparent text-base leading-6 font-medium rounded-md text-white \
                                     bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 \
                                     focus:ring-indigo active:bg-indigo-700 transition ease-in-out duration-150"
                                  ]
                              ]
                            [ txt "Let's talk" ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let make () =
  Layout.make
    ~title:"Consulting · Sapiens"
    [ Marketing_navbar.make ()
    ; Marketing_layout.simple_hero
        ~title:"Consulting"
        ~subtitle:
          "Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui lorem cupidatat commodo. Elit sunt amet \
           fugiat veniam occaecat fugiat aliqua."
        ()
    ; content ()
    ; contact_form ()
    ; Marketing_layout.footer ()
    ]
