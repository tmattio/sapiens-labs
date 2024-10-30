let createElement () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  div
    ~a:[ a_custom "x-data" "{ mobileMenuOpen: false }"; a_class [ "relative bg-gray-800" ] ]
    [ div
        ~a:[ a_class [ "flex justify-between items-center px-4 py-6 sm:px-6 md:justify-start md:space-x-10" ] ]
        [ div
            [ a
                ~a:[ a_href "/"; a_class [ "flex" ] ]
                [ img
                    ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-on-white.svg"
                    ~alt:"Sapiens Labs"
                    ~a:[ a_class [ "h-8 w-auto sm:h-10" ] ]
                    ()
                ]
            ]
        ; div
            ~a:[ a_class [ "-mr-2 -my-2 md:hidden" ] ]
            [ button
                ~a:
                  [ a_custom "@click" "mobileMenuOpen = true"
                  ; a_button_type `Button
                  ; a_class
                      [ "inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 \
                         hover:bg-gray-100 focus:outline-none focus:bg-gray-100 focus:text-gray-500 transition \
                         duration-150 ease-in-out"
                      ]
                  ]
                [ svg
                    ~a:
                      [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                      ; Tyxml.Svg.a_fill `None
                      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                      ; Tyxml.Svg.a_stroke `CurrentColor
                      ]
                    [ Tyxml.Svg.path
                        ~a:
                          [ a_svg_custom "stroke-linecap" "round"
                          ; a_svg_custom "stroke-linejoin" "round"
                          ; a_svg_custom "stroke-width" "2"
                          ; Tyxml.Svg.a_d "M4 6h16M4 12h16M4 18h16"
                          ]
                        []
                    ]
                ]
            ]
        ; div
            ~a:[ a_class [ "hidden md:flex-1 md:flex md:items-center md:justify-between md:space-x-12" ] ]
            [ nav
                ~a:[ a_class [ "flex space-x-10" ] ]
                [ div
                    ~a:
                      [ a_custom "x-data" "{ flyoutMenuOpen: false }"
                      ; a_custom "@click.away" "flyoutMenuOpen = false"
                      ; a_class [ "relative" ]
                      ]
                    [ button
                        ~a:
                          [ a_button_type `Button
                          ; a_custom "@click" "flyoutMenuOpen = !flyoutMenuOpen"
                          ; a_custom "x-state:on" "Item active"
                          ; a_custom "x-state:off" "Item inactive"
                          ; a_custom ":class" "{ 'text-gray-300': flyoutMenuOpen, 'text-white': !flyoutMenuOpen }"
                          ; a_class
                              [ "group inline-flex items-center space-x-2 text-base leading-6 font-medium \
                                 hover:text-gray-300 focus:outline-none focus:text-gray-300 transition ease-in-out \
                                 duration-150 text-white"
                              ]
                          ]
                        [ span [ txt "Features" ]
                        ; svg
                            ~a:
                              [ a_svg_custom "x-state:on" "Item active"
                              ; a_svg_custom "x-state:off" "Item inactive"
                              ; Tyxml.Svg.a_class
                                  [ "h-5 w-5 group-hover:text-gray-400 group-focus:text-gray-400 transition \
                                     ease-in-out duration-150 text-gray-300"
                                  ]
                              ; a_svg_custom
                                  ":class"
                                  "{ 'text-gray-400': flyoutMenuOpen, 'text-gray-300': !flyoutMenuOpen }"
                              ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                              ; Tyxml.Svg.a_fill `CurrentColor
                              ]
                            [ Tyxml.Svg.path
                                ~a:
                                  [ a_svg_custom "fill-rule" "evenodd"
                                  ; Tyxml.Svg.a_d
                                      "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 \
                                       0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                  ; a_svg_custom "clip-rule" "evenodd"
                                  ]
                                []
                            ]
                        ]
                    ; div
                        ~a:
                          [ a_custom "x-description" "'Features' flyout menu, show/hide based on flyout menu state."
                          ; a_custom "x-show" "flyoutMenuOpen"
                          ; a_custom "x-transition:enter" "transition ease-out duration-200"
                          ; a_custom "x-transition:enter-start" "opacity-0 translate-y-1"
                          ; a_custom "x-transition:enter-end" "opacity-100 translate-y-0"
                          ; a_custom "x-transition:leave" "transition ease-in duration-150"
                          ; a_custom "x-transition:leave-start" "opacity-100 translate-y-0"
                          ; a_custom "x-transition:leave-end" "opacity-0 translate-y-1"
                          ; a_class [ "absolute -ml-4 mt-3 transform w-screen max-w-md lg:max-w-3xl z-10" ]
                          ; a_style "display: none;"
                          ]
                        [ div
                            ~a:[ a_class [ "rounded-lg shadow-lg" ] ]
                            [ div
                                ~a:[ a_class [ "rounded-lg ring-1 ring-black ring-opacity-5 overflow-hidden" ] ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "z-20 relative grid gap-6 bg-white px-5 py-6 sm:gap-8 sm:p-8 lg:grid-cols-2"
                                          ]
                                      ]
                                    [ a
                                        ~a:
                                          [ a_href "/features/analytics"
                                          ; a_class
                                              [ "-m-3 p-3 flex items-start space-x-4 rounded-lg hover:bg-gray-50 \
                                                 transition ease-in-out duration-150"
                                              ]
                                          ]
                                        [ div
                                            ~a:
                                              [ a_class
                                                  [ "flex-shrink-0 flex items-center justify-center h-10 w-10 \
                                                     rounded-md bg-indigo-500 text-white sm:h-12 sm:w-12 "
                                                  ]
                                              ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                          "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 \
                                                           002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 \
                                                           2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 \
                                                           01-2 2h-2a2 2 0 01-2-2z"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; div
                                            ~a:[ a_class [ "space-y-1" ] ]
                                            [ p
                                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                                [ txt "Analytics" ]
                                            ; p
                                                ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                                [ txt "Analyse your dataset and get insights on how to improve them." ]
                                            ]
                                        ]
                                    ; a
                                        ~a:
                                          [ a_href "/features/annotation"
                                          ; a_class
                                              [ "-m-3 p-3 flex items-start space-x-4 rounded-lg hover:bg-gray-50 \
                                                 transition ease-in-out duration-150"
                                              ]
                                          ]
                                        [ div
                                            ~a:
                                              [ a_class
                                                  [ "flex-shrink-0 flex items-center justify-center h-10 w-10 \
                                                     rounded-md bg-indigo-500 text-white sm:h-12 sm:w-12 "
                                                  ]
                                              ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                          "M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 \
                                                           2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 \
                                                           2.122m-5.657 5.656l-2.12 2.122"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; div
                                            ~a:[ a_class [ "space-y-1" ] ]
                                            [ p
                                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                                [ txt "Annotation" ]
                                            ; p
                                                ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                                [ txt "Transform your raw data into quality machine learning datasets."
                                                ]
                                            ]
                                        ]
                                    ; a
                                        ~a:
                                          [ a_href "/features/model-training"
                                          ; a_class
                                              [ "-m-3 p-3 flex items-start space-x-4 rounded-lg hover:bg-gray-50 \
                                                 transition ease-in-out duration-150"
                                              ]
                                          ]
                                        [ div
                                            ~a:
                                              [ a_class
                                                  [ "flex-shrink-0 flex items-center justify-center h-10 w-10 \
                                                     rounded-md bg-indigo-500 text-white sm:h-12 sm:w-12 "
                                                  ]
                                              ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                          "M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 \
                                                           11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; div
                                            ~a:[ a_class [ "space-y-1" ] ]
                                            [ p
                                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                                [ txt "Model training" ]
                                            ; p
                                                ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                                [ txt "Train state-of-the-art machine learning models in one click." ]
                                            ]
                                        ]
                                    ; a
                                        ~a:
                                          [ a_href "/features/model-deployment"
                                          ; a_class
                                              [ "-m-3 p-3 flex items-start space-x-4 rounded-lg hover:bg-gray-50 \
                                                 transition ease-in-out duration-150"
                                              ]
                                          ]
                                        [ div
                                            ~a:
                                              [ a_class
                                                  [ "flex-shrink-0 flex items-center justify-center h-10 w-10 \
                                                     rounded-md bg-indigo-500 text-white sm:h-12 sm:w-12 "
                                                  ]
                                              ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; div
                                            ~a:[ a_class [ "space-y-1" ] ]
                                            [ p
                                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                                [ txt "Model deployment" ]
                                            ; p
                                                ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                                                [ txt "Deploy and monitor APIs to serve your machine learning models." ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ; a
                    ~a:
                      [ a_href "/pricing"
                      ; a_class
                          [ "text-base leading-6 font-medium text-white hover:text-gray-300 focus:outline-none \
                             focus:text-gray-300 transition ease-in-out duration-150"
                          ]
                      ]
                    [ txt "Pricing" ]
                ; a
                    ~a:
                      [ a_href "/consulting"
                      ; a_class
                          [ "text-base leading-6 font-medium text-white hover:text-gray-300 focus:outline-none \
                             focus:text-gray-300 transition ease-in-out duration-150"
                          ]
                      ]
                    [ txt "Consulting" ]
                ]
            ; div
                ~a:[ a_class [ "flex items-center space-x-8" ] ]
                [ a
                    ~a:
                      [ a_href "/users/login"
                      ; a_class
                          [ "text-base leading-6 font-medium text-white hover:text-gray-300 focus:outline-none \
                             focus:text-gray-300 transition ease-in-out duration-150"
                          ]
                      ]
                    [ txt "Sign in" ]
                ; span
                    ~a:[ a_class [ "inline-flex rounded-md shadow-sm" ] ]
                    [ a
                        ~a:
                          [ a_href "/users/register"
                          ; a_class
                              [ "inline-flex items-center justify-center px-4 py-2 border border-transparent text-base \
                                 leading-6 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                                 focus:outline-none focus:border-indigo-700 focus:ring-indigo active:bg-indigo-700 \
                                 transition ease-in-out duration-150"
                              ]
                          ]
                        [ txt "Sign up" ]
                    ]
                ]
            ]
        ]
    ; div
        ~a:
          [ a_custom "x-description" "Mobile menu, show/hide based on mobile menu state."
          ; a_custom "x-show" "mobileMenuOpen"
          ; a_custom "x-transition:enter" "duration-200 ease-out"
          ; a_custom "x-transition:enter-start" "opacity-0 scale-95"
          ; a_custom "x-transition:enter-end" "opacity-100 scale-100"
          ; a_custom "x-transition:leave" "duration-100 ease-in"
          ; a_custom "x-transition:leave-start" "opacity-100 scale-100"
          ; a_custom "x-transition:leave-end" "opacity-0 scale-95"
          ; a_class [ "absolute top-0 inset-x-0 p-2 transition transform origin-top-right md:hidden z-10" ]
          ]
        [ div
            ~a:[ a_class [ "rounded-lg shadow-lg" ] ]
            [ div
                ~a:[ a_class [ "rounded-lg ring-1 ring-black ring-opacity-5 bg-white divide-y-2 divide-gray-50" ] ]
                [ div
                    ~a:[ a_class [ "pt-5 pb-6 px-5 space-y-6" ] ]
                    [ div
                        ~a:[ a_class [ "flex items-center justify-between" ] ]
                        [ div
                            [ img
                                ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-on-white.svg"
                                ~alt:"Sapiens Labs"
                                ~a:[ a_class [ "h-8 w-auto" ] ]
                                ()
                            ]
                        ; div
                            ~a:[ a_class [ "-mr-2" ] ]
                            [ button
                                ~a:
                                  [ a_custom "@click" "mobileMenuOpen = false"
                                  ; a_button_type `Button
                                  ; a_class
                                      [ "inline-flex items-center justify-center p-2 rounded-md text-gray-400 \
                                         hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 \
                                         focus:text-gray-500 transition duration-150 ease-in-out"
                                      ]
                                  ]
                                [ svg
                                    ~a:
                                      [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                      ; Tyxml.Svg.a_fill `None
                                      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                      ; Tyxml.Svg.a_stroke `CurrentColor
                                      ]
                                    [ Tyxml.Svg.path
                                        ~a:
                                          [ a_svg_custom "stroke-linecap" "round"
                                          ; a_svg_custom "stroke-linejoin" "round"
                                          ; a_svg_custom "stroke-width" "2"
                                          ; Tyxml.Svg.a_d "M6 18L18 6M6 6l12 12"
                                          ]
                                        []
                                    ]
                                ]
                            ]
                        ]
                    ; div
                        [ nav
                            ~a:[ a_class [ "grid gap-6" ] ]
                            [ a
                                ~a:
                                  [ a_href "/features/analytics"
                                  ; a_class
                                      [ "-m-3 p-3 flex items-center space-x-4 rounded-lg hover:bg-gray-50 transition \
                                         ease-in-out duration-150"
                                      ]
                                  ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex-shrink-0 flex items-center justify-center h-10 w-10 rounded-md \
                                             bg-indigo-500 text-white"
                                          ]
                                      ]
                                    [ svg
                                        ~a:
                                          [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                  "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 \
                                                   0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 \
                                                   0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                                              ]
                                            []
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Analytics" ]
                                ]
                            ; a
                                ~a:
                                  [ a_href "/features/annotation"
                                  ; a_class
                                      [ "-m-3 p-3 flex items-center space-x-4 rounded-lg hover:bg-gray-50 transition \
                                         ease-in-out duration-150"
                                      ]
                                  ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex-shrink-0 flex items-center justify-center h-10 w-10 rounded-md \
                                             bg-indigo-500 text-white"
                                          ]
                                      ]
                                    [ svg
                                        ~a:
                                          [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                  "M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 \
                                                   7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122"
                                              ]
                                            []
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Annotation" ]
                                ]
                            ; a
                                ~a:
                                  [ a_href "/features/model-training"
                                  ; a_class
                                      [ "-m-3 p-3 flex items-center space-x-4 rounded-lg hover:bg-gray-50 transition \
                                         ease-in-out duration-150"
                                      ]
                                  ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex-shrink-0 flex items-center justify-center h-10 w-10 rounded-md \
                                             bg-indigo-500 text-white"
                                          ]
                                      ]
                                    [ svg
                                        ~a:
                                          [ Tyxml.Svg.a_class [ "h-6 w-6" ]
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
                                                  "M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 \
                                                   0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                                              ]
                                            []
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Model training" ]
                                ]
                            ; a
                                ~a:
                                  [ a_href "/features/model-deployment"
                                  ; a_class
                                      [ "-m-3 p-3 flex items-center space-x-4 rounded-lg hover:bg-gray-50 transition \
                                         ease-in-out duration-150"
                                      ]
                                  ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex-shrink-0 flex items-center justify-center h-10 w-10 rounded-md \
                                             bg-indigo-500 text-white"
                                          ]
                                      ]
                                    [ svg
                                        ~a:
                                          [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                          ; Tyxml.Svg.a_fill `None
                                          ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                          ; Tyxml.Svg.a_stroke `CurrentColor
                                          ]
                                        [ Tyxml.Svg.path
                                            ~a:
                                              [ a_svg_custom "stroke-linecap" "round"
                                              ; a_svg_custom "stroke-linejoin" "round"
                                              ; a_svg_custom "stroke-width" "2"
                                              ; Tyxml.Svg.a_d "M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
                                              ]
                                            []
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Model deployment" ]
                                ]
                            ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "py-6 px-5 space-y-6" ] ]
                    [ div
                        ~a:[ a_class [ "grid grid-cols-2 gap-4" ] ]
                        [ a
                            ~a:
                              [ a_href "/pricing"
                              ; a_class
                                  [ "text-base leading-6 font-medium text-gray-900 hover:text-gray-700 transition \
                                     ease-in-out duration-150"
                                  ]
                              ]
                            [ txt "Pricing" ]
                        ; a
                            ~a:
                              [ a_href "/consulting"
                              ; a_class
                                  [ "text-base leading-6 font-medium text-gray-900 hover:text-gray-700 transition \
                                     ease-in-out duration-150"
                                  ]
                              ]
                            [ txt "Consulting" ]
                        ]
                    ; div
                        ~a:[ a_class [ "space-y-6" ] ]
                        [ span
                            ~a:[ a_class [ "w-full flex rounded-md shadow-sm" ] ]
                            [ a
                                ~a:
                                  [ a_href "/users/register"
                                  ; a_class
                                      [ "w-full flex items-center justify-center px-4 py-2 border border-transparent \
                                         text-base leading-6 font-medium rounded-md text-white bg-indigo-600 \
                                         hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 \
                                         focus:ring-indigo active:bg-indigo-700 transition ease-in-out duration-150"
                                      ]
                                  ]
                                [ txt "Sign up" ]
                            ]
                        ; p
                            ~a:[ a_class [ "text-center text-base leading-6 font-medium text-gray-500" ] ]
                            [ txt "Already have an account? "
                            ; a
                                ~a:
                                  [ a_href "/users/login"
                                  ; a_class
                                      [ "text-indigo-600 hover:text-indigo-500 transition ease-in-out duration-150" ]
                                  ]
                                [ txt "Sign in" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let make () = createElement ()
