let createElement () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  div
    ~a:[ a_class [ "relative bg-gray-800 overflow-hidden" ] ]
    [ div
        ~a:[ a_class [ "hidden sm:block sm:absolute sm:inset-0" ] ]
        [ svg
            ~a:
              [ Tyxml.Svg.a_class
                  [ "absolute bottom-0 right-0 transform translate-x-1/2 mb-48 text-gray-700 lg:top-0 lg:mt-28 lg:mb-0 \
                     xl:transform-none xl:translate-x-0"
                  ]
              ; Tyxml.Svg.a_width (364., None)
              ; Tyxml.Svg.a_height (384., None)
              ; Tyxml.Svg.a_viewBox (0., 0., 364., 384.)
              ; Tyxml.Svg.a_fill `None
              ]
            [ Tyxml.Svg.defs
                [ Tyxml.Svg.pattern
                    ~a:
                      [ Tyxml.Svg.a_id "eab71dd9-9d7a-47bd-8044-256344ee00d0"
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
                          ; Tyxml.Svg.a_fill `CurrentColor
                          ]
                        []
                    ]
                ]
            ; Tyxml.Svg.rect
                ~a:
                  [ Tyxml.Svg.a_width (364., None)
                  ; Tyxml.Svg.a_height (384., None)
                  ; Tyxml.Svg.a_fill (`Icc ("#eab71dd9-9d7a-47bd-8044-256344ee00d0", None))
                  ]
                []
            ]
        ]
    ; div
        ~a:[ a_custom "x-data" "{ open: false }"; a_class [ "relative pb-12 sm:pb-32" ] ]
        [ main
            ~a:[ a_class [ "mt-8 sm:mt-16 md:mt-20 lg:mt-24" ] ]
            [ div
                ~a:[ a_class [ "mx-auto max-w-screen-xl" ] ]
                [ div
                    ~a:[ a_class [ "lg:grid lg:grid-cols-12 lg:gap-8" ] ]
                    [ div
                        ~a:
                          [ a_class
                              [ "px-4 sm:px-6 sm:text-center md:max-w-2xl md:mx-auto lg:col-span-6 lg:text-left \
                                 lg:flex lg:items-center"
                              ]
                          ]
                        [ div
                            [ h2
                                ~a:
                                  [ a_class
                                      [ "mt-4 text-4xl tracking-tight leading-10 font-extrabold text-white sm:mt-5 \
                                         sm:leading-none sm:text-6xl lg:mt-6 lg:text-5xl xl:text-6xl"
                                      ]
                                  ]
                                [ txt "Made for "
                                ; br ~a:[ a_class [ "hidden md:inline" ] ] ()
                                ; span ~a:[ a_class [ "text-indigo-400" ] ] [ txt "Data Scientists" ]
                                ]
                            ; p
                                ~a:
                                  [ a_class [ "mt-3 text-base text-gray-300 sm:mt-5 sm:text-xl lg:text-lg xl:text-xl" ]
                                  ]
                                [ txt
                                    "Sapiens supports you at every step of your data science project and automate \
                                     every thing that can be to let you focus on what really matters: "
                                ; b [ txt "building a great products." ]
                                ]
                            ; p
                                ~a:
                                  [ a_class [ "mt-8 text-sm text-white uppercase tracking-wide font-semibold sm:mt-10" ]
                                  ]
                                [ txt "Used by" ]
                            ; div
                                ~a:[ a_class [ "mt-5 w-full sm:mx-auto sm:max-w-lg lg:ml-0" ] ]
                                [ div
                                    ~a:[ a_class [ "flex flex-wrap items-start justify-between" ] ]
                                    [ div
                                        ~a:[ a_class [ "flex justify-center px-1" ] ]
                                        [ img
                                            ~src:"https://tailwindui.com/img/logos/v1/tuple-logo.svg"
                                            ~alt:"Tuple"
                                            ~a:[ a_class [ "h-9 sm:h-10" ] ]
                                            ()
                                        ]
                                    ; div
                                        ~a:[ a_class [ "flex justify-center px-1" ] ]
                                        [ img
                                            ~src:"https://tailwindui.com/img/logos/v1/workcation-logo.svg"
                                            ~alt:"Workcation"
                                            ~a:[ a_class [ "h-9 sm:h-10" ] ]
                                            ()
                                        ]
                                    ; div
                                        ~a:[ a_class [ "flex justify-center px-1" ] ]
                                        [ img
                                            ~src:"https://tailwindui.com/img/logos/v1/statickit-logo.svg"
                                            ~alt:"StaticKit"
                                            ~a:[ a_class [ "h-9 sm:h-10" ] ]
                                            ()
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-12 sm:mt-16 lg:mt-0 lg:col-span-6" ] ]
                        [ div
                            ~a:
                              [ a_class [ "bg-white sm:max-w-md sm:w-full sm:mx-auto sm:rounded-lg sm:overflow-hidden" ]
                              ]
                            [ div
                                ~a:[ a_class [ "px-4 py-8 sm:px-10" ] ]
                                [ div
                                    ~a:[ a_class [ "mt-6" ] ]
                                    [ form
                                        ~a:[ a_action "/users/register"; a_method `Post; a_class [ "space-y-6" ] ]
                                        [ Input.make
                                            ~id:"username"
                                            ~name:"username"
                                            ~label:"Username"
                                            ~type_:`Text
                                            ~required:true
                                            ()
                                        ; Input.make
                                            ~id:"email"
                                            ~name:"email"
                                            ~label:"Email"
                                            ~type_:`Email
                                            ~required:true
                                            ()
                                        ; Input.make
                                            ~id:"password"
                                            ~name:"password"
                                            ~label:"Password"
                                            ~type_:`Password
                                            ~required:true
                                            ()
                                        ; div
                                            [ span
                                                ~a:[ a_class [ "block w-full rounded-md shadow-sm" ] ]
                                                [ button
                                                    ~a:
                                                      [ a_button_type `Submit
                                                      ; a_class
                                                          [ "w-full flex justify-center py-2 px-4 border \
                                                             border-transparent rounded-md shadow-sm text-sm \
                                                             font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                                             focus:outline-none focus:ring-2 focus:ring-offset-2 \
                                                             focus:ring-indigo-500"
                                                          ]
                                                      ]
                                                    [ txt "Create your account" ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ; div
                                ~a:[ a_class [ "px-4 py-6 bg-gray-50 border-t-2 border-gray-200 sm:px-10" ] ]
                                [ p
                                    ~a:[ a_class [ "text-xs leading-5 text-gray-500" ] ]
                                    [ txt "By signing up, you agree to our "
                                    ; a
                                        ~a:[ a_href "/terms"; a_class [ "font-medium text-gray-900 hover:underline" ] ]
                                        [ txt "Terms" ]
                                    ; txt " and "
                                    ; a
                                        ~a:
                                          [ a_href "/privacy"; a_class [ "font-medium text-gray-900 hover:underline" ] ]
                                        [ txt "Privacy Policy" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let make () = createElement ()
