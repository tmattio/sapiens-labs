let cta () =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "bg-gray-800" ] ]
    [ div
        ~a:
          [ a_class
              [ "max-w-screen-xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8 lg:flex lg:items-center lg:justify-between"
              ]
          ]
        [ h2
            ~a:[ a_class [ "text-3xl leading-9 font-extrabold tracking-tight text-white sm:text-4xl sm:leading-10" ] ]
            [ txt "Ready to dive in?"
            ; br ()
            ; span ~a:[ a_class [ "text-indigo-400" ] ] [ txt "Start your free trial today." ]
            ]
        ; div
            ~a:[ a_class [ "mt-8 flex lg:flex-shrink-0 lg:mt-0" ] ]
            [ div
                ~a:[ a_class [ "inline-flex rounded-md shadow" ] ]
                [ a
                    ~a:
                      [ a_href "/users/register"
                      ; a_class
                          [ "inline-flex items-center justify-center px-5 py-3 border border-transparent text-base \
                             leading-6 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                             focus:outline-none focus:ring transition duration-150 ease-in-out"
                          ]
                      ]
                    [ txt "Get started" ]
                ]
            ; div
                ~a:[ a_class [ "ml-3 inline-flex rounded-md shadow" ] ]
                [ a
                    ~a:
                      [ a_href "/about"
                      ; a_class
                          [ "inline-flex items-center justify-center px-5 py-3 border border-transparent text-base \
                             leading-6 font-medium rounded-md text-indigo-600 bg-white hover:text-indigo-500 \
                             focus:outline-none focus:ring transition duration-150 ease-in-out"
                          ]
                      ]
                    [ txt "Learn more" ]
                ]
            ]
        ]
    ]

let feature_preview () =
  let open Tyxml.Html in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  div
    ~a:[ a_class [ "py-16 bg-white overflow-hidden lg:py-24" ] ]
    [ div
        ~a:[ a_class [ "relative max-w-xl mx-auto px-4 sm:px-6 lg:px-8 lg:max-w-screen-xl" ] ]
        [ svg
            ~a:
              [ Tyxml.Svg.a_class [ "hidden lg:block absolute left-full transform -translate-x-1/2 -translate-y-1/4" ]
              ; Tyxml.Svg.a_width (404., None)
              ; Tyxml.Svg.a_height (784., None)
              ; Tyxml.Svg.a_fill `None
              ; Tyxml.Svg.a_viewBox (0., 0., 404., 784.)
              ]
            [ Tyxml.Svg.defs
                [ Tyxml.Svg.pattern
                    ~a:
                      [ Tyxml.Svg.a_id "b1e6e422-73f8-40a6-b5d9-c8586e37e0e7"
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
                  ; Tyxml.Svg.a_height (784., None)
                  ; Tyxml.Svg.a_fill (`Icc ("#b1e6e422-73f8-40a6-b5d9-c8586e37e0e7", None))
                  ]
                []
            ]
        ; div
            ~a:[ a_class [ "relative" ] ]
            [ h3
                ~a:
                  [ a_class
                      [ "text-center text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl \
                         sm:leading-10"
                      ]
                  ]
                [ txt "A better way to do Machine Learning" ]
            ; p
                ~a:[ a_class [ "mt-4 max-w-3xl mx-auto text-center text-xl leading-7 text-gray-500" ] ]
                [ txt
                    "Lorem ipsum dolor sit amet consectetur adipisicing elit. Possimus magnam voluptatum cupiditate \
                     veritatis in, accusamus quisquam."
                ]
            ]
        ; div
            ~a:[ a_class [ "relative mt-12 lg:mt-24 lg:grid lg:grid-cols-2 lg:gap-8 lg:items-center" ] ]
            [ div
                ~a:[ a_class [ "relative" ] ]
                [ h4
                    ~a:
                      [ a_class
                          [ "text-2xl leading-8 font-extrabold text-gray-900 tracking-tight sm:text-3xl sm:leading-9" ]
                      ]
                    [ txt "Hosting" ]
                ; p
                    ~a:[ a_class [ "mt-3 text-lg leading-7 text-gray-500" ] ]
                    [ txt
                        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Pariatur minima sequi recusandae, \
                         porro maiores officia assumenda aliquam laborum ab aliquid veritatis impedit odit adipisci \
                         optio iste blanditiis facere. Totam, velit."
                    ]
                ; ul
                    ~a:[ a_class [ "mt-10" ] ]
                    [ li
                        [ div
                            ~a:[ a_class [ "flex" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0" ] ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 \
                                             text-white"
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
                                                  "M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 \
                                                   9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 \
                                                   3-9m-9 9a9 9 0 019-9"
                                              ]
                                            []
                                        ]
                                    ]
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ h5
                                    ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Never loose any data" ]
                                ; p
                                    ~a:[ a_class [ "mt-2 text-base leading-6 text-gray-500" ] ]
                                    [ txt
                                        "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Maiores impedit \
                                         perferendis suscipit eaque, iste dolor cupiditate blanditiis ratione."
                                    ]
                                ]
                            ]
                        ]
                    ; li
                        ~a:[ a_class [ "mt-10" ] ]
                        [ div
                            ~a:[ a_class [ "flex" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0" ] ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 \
                                             text-white"
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
                                                  "M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 \
                                                   2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 \
                                                   16V5m0 16H9m3 0h3"
                                              ]
                                            []
                                        ]
                                    ]
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ h5
                                    ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Strict permission and access control" ]
                                ; p
                                    ~a:[ a_class [ "mt-2 text-base leading-6 text-gray-500" ] ]
                                    [ txt
                                        "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Maiores impedit \
                                         perferendis suscipit eaque, iste dolor cupiditate blanditiis ratione."
                                    ]
                                ]
                            ]
                        ]
                    ; li
                        ~a:[ a_class [ "mt-10" ] ]
                        [ div
                            ~a:[ a_class [ "flex" ] ]
                            [ div
                                ~a:[ a_class [ "flex-shrink-0" ] ]
                                [ div
                                    ~a:
                                      [ a_class
                                          [ "flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 \
                                             text-white"
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
                                              ; Tyxml.Svg.a_d "M13 10V3L4 14h7v7l9-11h-7z"
                                              ]
                                            []
                                        ]
                                    ]
                                ]
                            ; div
                                ~a:[ a_class [ "ml-4" ] ]
                                [ h5
                                    ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                    [ txt "Explore your data in new ways" ]
                                ; p
                                    ~a:[ a_class [ "mt-2 text-base leading-6 text-gray-500" ] ]
                                    [ txt
                                        "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Maiores impedit \
                                         perferendis suscipit eaque, iste dolor cupiditate blanditiis ratione."
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "mt-10 -mx-4 relative lg:mt-0" ] ]
                [ svg
                    ~a:
                      [ Tyxml.Svg.a_class [ "absolute left-1/2 transform -translate-x-1/2 translate-y-16 lg:hidden" ]
                      ; Tyxml.Svg.a_width (784., None)
                      ; Tyxml.Svg.a_height (404., None)
                      ; Tyxml.Svg.a_fill `None
                      ; Tyxml.Svg.a_viewBox (0., 0., 784., 404.)
                      ]
                    [ Tyxml.Svg.defs
                        [ Tyxml.Svg.pattern
                            ~a:
                              [ Tyxml.Svg.a_id "ca9667ae-9f92-4be7-abcb-9e3d727f2941"
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
                          [ Tyxml.Svg.a_width (784., None)
                          ; Tyxml.Svg.a_height (404., None)
                          ; Tyxml.Svg.a_fill (`Icc ("#ca9667ae-9f92-4be7-abcb-9e3d727f2941", None))
                          ]
                        []
                    ]
                ; img ~src:"/feature-example-2.png" ~alt:"" ~a:[ a_class [ "relative mx-auto" ]; a_width 490 ] ()
                ]
            ]
        ; svg
            ~a:
              [ Tyxml.Svg.a_class [ "hidden lg:block absolute right-full transform translate-x-1/2 translate-y-12" ]
              ; Tyxml.Svg.a_width (404., None)
              ; Tyxml.Svg.a_height (784., None)
              ; Tyxml.Svg.a_fill `None
              ; Tyxml.Svg.a_viewBox (0., 0., 404., 784.)
              ]
            [ Tyxml.Svg.defs
                [ Tyxml.Svg.pattern
                    ~a:
                      [ Tyxml.Svg.a_id "64e643ad-2176-4f86-b3d7-f2c5da3b6a6d"
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
                  ; Tyxml.Svg.a_height (784., None)
                  ; Tyxml.Svg.a_fill (`Icc ("#64e643ad-2176-4f86-b3d7-f2c5da3b6a6d", None))
                  ]
                []
            ]
        ; div
            ~a:[ a_class [ "relative mt-12 sm:mt-16 lg:mt-24" ] ]
            [ div
                ~a:[ a_class [ "lg:grid lg:grid-flow-row-dense lg:grid-cols-2 lg:gap-8 lg:items-center" ] ]
                [ div
                    ~a:[ a_class [ "lg:col-start-2" ] ]
                    [ h4
                        ~a:
                          [ a_class
                              [ "text-2xl leading-8 font-extrabold text-gray-900 tracking-tight sm:text-3xl \
                                 sm:leading-9"
                              ]
                          ]
                        [ txt "World-class model training tooling" ]
                    ; p
                        ~a:[ a_class [ "mt-3 text-lg leading-7 text-gray-500" ] ]
                        [ txt
                            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Impedit ex obcaecati natus \
                             eligendi delectus, cum deleniti sunt in labore nihil quod quibusdam expedita nemo."
                        ]
                    ; ul
                        ~a:[ a_class [ "mt-10" ] ]
                        [ li
                            [ div
                                ~a:[ a_class [ "flex" ] ]
                                [ div
                                    ~a:[ a_class [ "flex-shrink-0" ] ]
                                    [ div
                                        ~a:
                                          [ a_class
                                              [ "flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 \
                                                 text-white"
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
                                                      "M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 \
                                                       012 2v8a2 2 0 01-2 2h-3l-4 4z"
                                                  ]
                                                []
                                            ]
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "ml-4" ] ]
                                    [ h5
                                        ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                        [ txt "Train a model in a click" ]
                                    ; p
                                        ~a:[ a_class [ "mt-2 text-base leading-6 text-gray-500" ] ]
                                        [ txt
                                            "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Maiores impedit \
                                             perferendis suscipit eaque, iste dolor cupiditate blanditiis ratione."
                                        ]
                                    ]
                                ]
                            ]
                        ; li
                            ~a:[ a_class [ "mt-10" ] ]
                            [ div
                                ~a:[ a_class [ "flex" ] ]
                                [ div
                                    ~a:[ a_class [ "flex-shrink-0" ] ]
                                    [ div
                                        ~a:
                                          [ a_class
                                              [ "flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 \
                                                 text-white"
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
                                                      "M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 \
                                                       00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                                                  ]
                                                []
                                            ]
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "ml-4" ] ]
                                    [ h5
                                        ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ]
                                        [ txt "Keep track of all your experiments" ]
                                    ; p
                                        ~a:[ a_class [ "mt-2 text-base leading-6 text-gray-500" ] ]
                                        [ txt
                                            "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Maiores impedit \
                                             perferendis suscipit eaque, iste dolor cupiditate blanditiis ratione."
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ; div
                    ~a:[ a_class [ "mt-10 -mx-4 relative lg:mt-0 lg:col-start-1" ] ]
                    [ svg
                        ~a:
                          [ Tyxml.Svg.a_class
                              [ "absolute left-1/2 transform -translate-x-1/2 translate-y-16 lg:hidden" ]
                          ; Tyxml.Svg.a_width (784., None)
                          ; Tyxml.Svg.a_height (404., None)
                          ; Tyxml.Svg.a_fill `None
                          ; Tyxml.Svg.a_viewBox (0., 0., 784., 404.)
                          ]
                        [ Tyxml.Svg.defs
                            [ Tyxml.Svg.pattern
                                ~a:
                                  [ Tyxml.Svg.a_id "e80155a9-dfde-425a-b5ea-1f6fadd20131"
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
                              [ Tyxml.Svg.a_width (784., None)
                              ; Tyxml.Svg.a_height (404., None)
                              ; Tyxml.Svg.a_fill (`Icc ("#e80155a9-dfde-425a-b5ea-1f6fadd20131", None))
                              ]
                            []
                        ]
                    ; img
                        ~src:"https://tailwindui.com/img/features/feature-example-2.png"
                        ~alt:""
                        ~a:[ a_class [ "relative mx-auto" ]; a_width 490 ]
                        ()
                    ]
                ]
            ]
        ]
    ]

let make () =
  Layout.make
    ~title:"Your machine learning platform · Sapiens"
    [ Marketing_navbar.make (); Marketing_hero.make (); feature_preview (); cta (); Marketing_layout.footer () ]
