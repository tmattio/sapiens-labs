module Footer = struct
  let createElement () =
    let open Tyxml.Html in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    div
      ~a:[ a_class [ "bg-white" ] ]
      [ div
          ~a:[ a_class [ "max-w-screen-xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8" ] ]
          [ div
              ~a:[ a_class [ "xl:grid xl:grid-cols-3 xl:gap-8" ] ]
              [ div
                  ~a:[ a_class [ "xl:col-span-1" ] ]
                  [ img
                      ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-gray-300.svg"
                      ~alt:"Company name"
                      ~a:[ a_class [ "h-10" ] ]
                      ()
                  ; p
                      ~a:[ a_class [ "mt-8 text-gray-500 text-base leading-6" ] ]
                      [ txt "End-to-end machine learning platform that support you at every step of your project." ]
                  ; div
                      ~a:[ a_class [ "mt-8 flex" ] ]
                      [ a
                          ~a:[ a_href "#"; a_class [ "text-gray-400 hover:text-gray-500" ] ]
                          [ span ~a:[ a_class [ "sr-only" ] ] [ txt "Twitter" ]
                          ; svg
                              ~a:
                                [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                ; Tyxml.Svg.a_fill `CurrentColor
                                ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                ]
                              [ Tyxml.Svg.path
                                  ~a:
                                    [ Tyxml.Svg.a_d
                                        "M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 \
                                         8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 \
                                         8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 \
                                         01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 \
                                         9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 \
                                         0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"
                                    ]
                                  []
                              ]
                          ]
                      ; a
                          ~a:[ a_href "#"; a_class [ "ml-6 text-gray-400 hover:text-gray-500" ] ]
                          [ span ~a:[ a_class [ "sr-only" ] ] [ txt "GitHub" ]
                          ; svg
                              ~a:
                                [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                ; Tyxml.Svg.a_fill `CurrentColor
                                ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                ]
                              [ Tyxml.Svg.path
                                  ~a:
                                    [ a_svg_custom "fill-rule" "evenodd"
                                    ; Tyxml.Svg.a_d
                                        "M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 \
                                         9.504.5.092.682-.217.682-.483 \
                                         0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 \
                                         1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 \
                                         2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 \
                                         0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 \
                                         1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 \
                                         2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 \
                                         2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 \
                                         2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 \
                                         17.522 2 12 2z"
                                    ; a_svg_custom "clip-rule" "evenodd"
                                    ]
                                  []
                              ]
                          ]
                      ; a
                          ~a:[ a_href "#"; a_class [ "ml-6 text-gray-400 hover:text-gray-500" ] ]
                          [ span ~a:[ a_class [ "sr-only" ] ] [ txt "Dribbble" ]
                          ; svg
                              ~a:
                                [ Tyxml.Svg.a_class [ "h-6 w-6" ]
                                ; Tyxml.Svg.a_fill `CurrentColor
                                ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                ]
                              [ Tyxml.Svg.path
                                  ~a:
                                    [ a_svg_custom "fill-rule" "evenodd"
                                    ; Tyxml.Svg.a_d
                                        "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10c5.51 0 10-4.48 10-10S17.51 2 12 \
                                         2zm6.605 4.61a8.502 8.502 0 011.93 \
                                         5.314c-.281-.054-3.101-.629-5.943-.271-.065-.141-.12-.293-.184-.445a25.416 \
                                         25.416 0 00-.564-1.236c3.145-1.28 4.577-3.124 4.761-3.362zM12 3.475c2.17 0 \
                                         4.154.813 5.662 2.148-.152.216-1.443 1.941-4.48 \
                                         3.08-1.399-2.57-2.95-4.675-3.189-5A8.687 8.687 0 0112 \
                                         3.475zm-3.633.803a53.896 53.896 0 013.167 4.935c-3.992 1.063-7.517 1.04-7.896 \
                                         1.04a8.581 8.581 0 014.729-5.975zM3.453 12.01v-.26c.37.01 4.512.065 \
                                         8.775-1.215.25.477.477.965.694 1.453-.109.033-.228.065-.336.098-4.404 \
                                         1.42-6.747 5.303-6.942 5.629a8.522 8.522 0 01-2.19-5.705zM12 20.547a8.482 \
                                         8.482 0 01-5.239-1.8c.152-.315 1.888-3.656 \
                                         6.703-5.337.022-.01.033-.01.054-.022a35.318 35.318 0 011.823 6.475 8.4 8.4 0 \
                                         01-3.341.684zm4.761-1.465c-.086-.52-.542-3.015-1.659-6.084 2.679-.423 \
                                         5.022.271 5.314.369a8.468 8.468 0 01-3.655 5.715z"
                                    ; a_svg_custom "clip-rule" "evenodd"
                                    ]
                                  []
                              ]
                          ]
                      ]
                  ]
              ; div
                  ~a:[ a_class [ "mt-12 grid grid-cols-3 gap-8 xl:mt-0 xl:col-span-2" ] ]
                  [ div
                      [ div
                          [ h4
                              ~a:
                                [ a_class [ "text-sm leading-5 font-semibold tracking-wider text-gray-400 uppercase" ] ]
                              [ txt "Features" ]
                          ; ul
                              ~a:[ a_class [ "mt-4" ] ]
                              [ li
                                  [ a
                                      ~a:
                                        [ a_href "/features/analytics"
                                        ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                        ]
                                      [ txt "Analytics" ]
                                  ]
                              ; li
                                  ~a:[ a_class [ "mt-4" ] ]
                                  [ a
                                      ~a:
                                        [ a_href "/features/annotation"
                                        ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                        ]
                                      [ txt "Annotation" ]
                                  ]
                              ; li
                                  ~a:[ a_class [ "mt-4" ] ]
                                  [ a
                                      ~a:
                                        [ a_href "/features/model-training"
                                        ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                        ]
                                      [ txt "Model training" ]
                                  ]
                              ; li
                                  ~a:[ a_class [ "mt-4" ] ]
                                  [ a
                                      ~a:
                                        [ a_href "/features/model-deployment"
                                        ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                        ]
                                      [ txt "Model deployment" ]
                                  ]
                              ]
                          ]
                      ]
                  ; div
                      [ h4
                          ~a:[ a_class [ "text-sm leading-5 font-semibold tracking-wider text-gray-400 uppercase" ] ]
                          [ txt "Company" ]
                      ; ul
                          ~a:[ a_class [ "mt-4" ] ]
                          [ li
                              [ a
                                  ~a:
                                    [ a_href "/about"
                                    ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                    ]
                                  [ txt "About" ]
                              ]
                          ; li
                              ~a:[ a_class [ "mt-4" ] ]
                              [ a
                                  ~a:
                                    [ a_href "/jobs"
                                    ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                    ]
                                  [ txt "Jobs" ]
                              ]
                          ]
                      ]
                  ; div
                      [ h4
                          ~a:[ a_class [ "text-sm leading-5 font-semibold tracking-wider text-gray-400 uppercase" ] ]
                          [ txt "Legal" ]
                      ; ul
                          ~a:[ a_class [ "mt-4" ] ]
                          [ li
                              ~a:[ a_class [ "mt-4" ] ]
                              [ a
                                  ~a:
                                    [ a_href "/terms"
                                    ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                    ]
                                  [ txt "Terms" ]
                              ]
                          ; li
                              ~a:[ a_class [ "mt-4" ] ]
                              [ a
                                  ~a:
                                    [ a_href "/privacy"
                                    ; a_class [ "text-base leading-6 text-gray-500 hover:text-gray-900" ]
                                    ]
                                  [ txt "Privacy" ]
                              ]
                          ]
                      ]
                  ]
              ]
          ; div
              ~a:[ a_class [ "mt-12 border-t border-gray-200 pt-8" ] ]
              [ p
                  ~a:[ a_class [ "text-base leading-6 text-gray-400 xl:text-center" ] ]
                  [ txt "\194\169 2020 Sapiens Labs, Inc. All rights reserved." ]
              ]
          ]
      ]
end

let footer () = Footer.createElement ()

module Simple_hero = struct
  let createElement ~title:title_ ~subtitle () =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "relative bg-gray-50 overflow-hidden" ] ]
      [ div
          ~a:[ a_class [ "hidden sm:block sm:absolute sm:inset-y-0 sm:h-full sm:w-full" ] ]
          [ div
              ~a:[ a_class [ "relative h-full max-w-screen-xl mx-auto" ] ]
              [ svg
                  ~a:
                    [ Tyxml.Svg.a_class
                        [ "absolute right-full transform translate-y-1/4 translate-x-1/4 lg:translate-x-1/2" ]
                    ; Tyxml.Svg.a_width (404., None)
                    ; Tyxml.Svg.a_height (784., None)
                    ; Tyxml.Svg.a_fill `None
                    ; Tyxml.Svg.a_viewBox (0., 0., 404., 784.)
                    ]
                  [ Tyxml.Svg.defs
                      [ Tyxml.Svg.pattern
                          ~a:
                            [ Tyxml.Svg.a_id "f210dbf6-a58d-4871-961e-36d5016a0f49"
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
                        ; Tyxml.Svg.a_fill (`Icc ("#f210dbf6-a58d-4871-961e-36d5016a0f49", None))
                        ]
                      []
                  ]
              ; svg
                  ~a:
                    [ Tyxml.Svg.a_class
                        [ "absolute left-full transform -translate-y-3/4 -translate-x-1/4 md:-translate-y-1/2 \
                           lg:-translate-x-1/2"
                        ]
                    ; Tyxml.Svg.a_width (404., None)
                    ; Tyxml.Svg.a_height (784., None)
                    ; Tyxml.Svg.a_fill `None
                    ; Tyxml.Svg.a_viewBox (0., 0., 404., 784.)
                    ]
                  [ Tyxml.Svg.defs
                      [ Tyxml.Svg.pattern
                          ~a:
                            [ Tyxml.Svg.a_id "5d0dd344-b041-4d26-bec4-8d33ea57ec9b"
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
                        ; Tyxml.Svg.a_fill (`Icc ("#5d0dd344-b041-4d26-bec4-8d33ea57ec9b", None))
                        ]
                      []
                  ]
              ]
          ]
      ; div
          ~a:[ a_class [ "relative pt-6 pb-12 sm:pb-16 md:pb-20 lg:pb-28 xl:pb-32" ] ]
          [ main
              ~a:[ a_class [ "mt-10 mx-auto max-w-screen-xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 xl:mt-28" ] ]
              [ div
                  ~a:[ a_class [ "text-center" ] ]
                  [ h2
                      ~a:
                        [ a_class
                            [ "text-4xl tracking-tight leading-10 font-extrabold text-gray-900 sm:text-5xl \
                               sm:leading-none md:text-6xl"
                            ]
                        ]
                      [ txt title_ ]
                  ; p
                      ~a:
                        [ a_class
                            [ "mt-3 max-w-md mx-auto text-base text-gray-500 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl"
                            ]
                        ]
                      [ txt subtitle ]
                  ]
              ]
          ]
      ]
end

let simple_hero = Simple_hero.createElement
