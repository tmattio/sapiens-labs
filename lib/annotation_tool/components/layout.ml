module Navbar = struct
  let make ~name ~guidelines ~total ~completed =
    let open Tyxml.Html in
    let total_flt = float_of_int total in
    let completed_flt = float_of_int completed in
    let pct =
      int_of_float ((1. -. ((total_flt -. completed_flt) /. total_flt)) *. 100.)
    in
    nav
      ~a:[ class_ "mt-5 flex-1 px-2 bg-gray-800 space-y-1" ]
      [ div
          ~a:[ class_ "mt-5" ]
          [ h3
              ~a:
                [ class_
                    "px-3 text-sm leading-4 font-semibold text-white uppercase \
                     tracking-wider"
                ]
              [ txt "Task Info" ]
          ; div
              ~a:
                [ a_aria "labelledby" [ "projects-headline" ]
                ; class_ "mt-2 space-y-1"
                ; a_role [ "group" ]
                ]
              [ div
                  ~a:[ class_ "flex px-3" ]
                  [ div
                      ~a:
                        [ class_
                            "flex-none text-gray-300 text-left text-sm \
                             font-bold pr-4"
                        ]
                      [ txt "Name" ]
                  ; div
                      ~a:
                        [ class_
                            "flex-1 text-gray-300 text-right text-sm truncate"
                        ]
                      [ txt name ]
                  ]
              ]
          ; (match guidelines with
            | None | Some "" ->
              div []
            | Some guidelines ->
              div
                ~a:
                  [ a_aria "labelledby" [ "projects-headline" ]
                  ; class_ "mt-2 space-y-1"
                  ; a_role [ "group" ]
                  ]
                [ div
                    ~a:[ class_ "flex px-3" ]
                    [ div
                        ~a:
                          [ class_
                              "flex-none text-gray-300 text-left text-sm \
                               font-bold pr-4"
                          ]
                        [ txt "Guidelines" ]
                    ; div
                        ~a:
                          [ class_
                              "flex-1 text-gray-300 text-right text-sm truncate"
                          ]
                        [ a ~a:[ a_href guidelines ] [ txt guidelines ] ]
                    ]
                ])
          ]
      ; div
          ~a:[ class_ "pt-8" ]
          [ h3
              ~a:
                [ class_
                    "px-3 text-sm leading-4 font-semibold text-white uppercase \
                     tracking-wider"
                ]
              [ txt "Progress" ]
          ; div
              ~a:
                [ a_aria "labelledby" [ "projects-headline" ]
                ; class_ "mt-1 space-y-1"
                ; a_role [ "group" ]
                ]
              [ div
                  ~a:[ class_ "px-3 py-2" ]
                  [ div
                      ~a:[ class_ "h-3 relative rounded-full overflow-hidden" ]
                      [ div
                          ~a:[ class_ "w-full h-full bg-gray-200 absolute" ]
                          []
                      ; div
                          ~a:
                            [ class_ "h-full bg-green-500 relative"
                            ; a_id "bar"
                            ; a_style ("width: " ^ string_of_int pct ^ "%;")
                            ]
                          []
                      ]
                  ]
              ; div
                  ~a:[ class_ "flex px-3" ]
                  [ div
                      ~a:
                        [ class_
                            "flex-none text-gray-300 text-left text-sm \
                             font-bold"
                        ]
                      [ txt "Total" ]
                  ; div
                      ~a:[ class_ "flex-1 text-gray-300 text-right text-sm" ]
                      [ txt (string_of_int total) ]
                  ]
              ; div
                  ~a:[ class_ "flex px-3" ]
                  [ div
                      ~a:
                        [ class_
                            "flex-none text-gray-300 text-left text-sm \
                             font-bold"
                        ]
                      [ txt "Done" ]
                  ; div
                      ~a:[ class_ "flex-1 text-gray-300 text-right text-sm" ]
                      [ txt (string_of_int completed) ]
                  ]
              ]
          ]
      ]
end

let make
    ~on_next
    ~on_previous
    ~on_validate
    ~(task : Sapiens_common.Annotation.user_annotation_task)
    children
  =
  let open Tyxml.Html in
  let a_svg_custom x y =
    Tyxml.Xml.string_attrib x (Lwd.pure y) |> Tyxml.Svg.to_attrib
  in
  let show_menu_v = Lwd.var false in
  let close_menu _ =
    Lwd.set show_menu_v false;
    false
  in
  let open_menu _ =
    Lwd.set show_menu_v true;
    false
  in
  let style_of_show_menu show_menu =
    if show_menu then "" else "display: none;"
  in
  div
    ~a:[ class_ "h-screen flex overflow-hidden bg-gray-100" ]
    [ div
        ~a:
          [ class_ "md:hidden"
          ; Tyxml_lwd.Html.a_style
              (Lwd.map ~f:style_of_show_menu (Lwd.get show_menu_v))
          ]
        [ div
            ~a:[ class_ "fixed inset-0 flex z-40" ]
            [ div
                ~a:
                  [ Tyxml_lwd.Html.a_class
                      (Lwd.map (Lwd.get show_menu_v) ~f:(fun show_menu ->
                           [ ("fixed inset-0 transition-opacity ease-linear \
                               duration-300"
                             ^
                             if show_menu then
                               " opacity-100"
                             else
                               " opacity-0")
                           ]))
                  ; Tyxml_lwd.Html.a_style
                      (Lwd.map ~f:style_of_show_menu (Lwd.get show_menu_v))
                  ; a_onclick close_menu
                  ]
                [ div ~a:[ class_ "absolute inset-0 bg-gray-600 opacity-75" ] []
                ]
            ; div
                ~a:
                  [ Tyxml_lwd.Html.a_class
                      (Lwd.map (Lwd.get show_menu_v) ~f:(fun show_menu ->
                           [ ("relative flex-1 flex flex-col max-w-xs w-full \
                               bg-gray-800 transition ease-in-out duration-300 \
                               transform"
                             ^
                             if show_menu then
                               " transition ease-in-out duration-300 transform \
                                translate-x-0"
                             else
                               " transition ease-in-out duration-300 transform \
                                -translate-x-full")
                           ]))
                  ; Tyxml_lwd.Html.a_style
                      (Lwd.map ~f:style_of_show_menu (Lwd.get show_menu_v))
                  ]
                [ div
                    ~a:[ class_ "absolute top-0 right-0 -mr-14 p-1" ]
                    [ button
                        ~a:
                          [ a_aria "label" [ "Close sidebar" ]
                          ; class_
                              "flex items-center justify-center h-12 w-12 \
                               rounded-full focus:outline-none \
                               focus:bg-gray-600"
                          ; a_onclick close_menu
                          ]
                        [ svg
                            ~a:
                              [ Tyxml.Svg.class_ "h-6 w-6 text-white"
                              ; Tyxml.Svg.a_fill `None
                              ; Tyxml.Svg.a_stroke `CurrentColor
                              ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                              ]
                            [ Tyxml.Svg.path
                                ~a:
                                  [ Tyxml.Svg.a_d "M6 18L18 6M6 6l12 12"
                                  ; a_svg_custom "stroke-linecap" "round"
                                  ; a_svg_custom "stroke-linejoin" "round"
                                  ; a_svg_custom "stroke-width" "2"
                                  ]
                                []
                            ]
                        ]
                    ]
                ; div
                    ~a:[ class_ "flex-1 h-0 pt-5 pb-4 overflow-y-auto" ]
                    [ div
                        ~a:[ class_ "flex-shrink-0 flex items-center px-4" ]
                        [ img
                            ~src:
                              "https://tailwindui.com/img/logos/v1/workflow-logo-on-dark.svg"
                            ~alt:"Workflow"
                            ~a:[ class_ "h-8 w-auto" ]
                            ()
                        ]
                    ; Navbar.make
                        ~name:task.name
                        ~guidelines:task.guidelines
                        ~total:(Helper.count_annotations task.annotations)
                        ~completed:(Helper.count_annotated task.annotations)
                    ]
                ; div
                    ~a:[ class_ "bg-gray-700 p-4" ]
                    [ p
                        ~a:
                          [ class_
                              "text-xs leading-4 text-center font-medium \
                               text-gray-300 group-hover:text-gray-200 \
                               transition ease-in-out duration-150"
                          ]
                        [ span [ txt "\194\169 2020 Sapiens Labs" ] ]
                    ]
                ]
            ; div ~a:[ class_ "flex-shrink-0 w-14" ] []
            ]
        ]
    ; div
        ~a:[ class_ "hidden md:flex md:flex-shrink-0" ]
        [ div
            ~a:[ class_ "flex flex-col w-72" ]
            [ div
                ~a:[ class_ "flex flex-col h-0 flex-1 bg-gray-800" ]
                [ div
                    ~a:
                      [ class_ "flex-1 flex flex-col pt-5 pb-4 overflow-y-auto"
                      ]
                    [ div
                        ~a:[ class_ "flex items-center flex-shrink-0 px-4" ]
                        [ img
                            ~src:
                              "https://tailwindui.com/img/logos/v1/workflow-logo-on-dark.svg"
                            ~alt:"Workflow"
                            ~a:[ class_ "h-8 w-auto" ]
                            ()
                        ]
                    ; Navbar.make
                        ~name:task.name
                        ~guidelines:task.guidelines
                        ~total:(Helper.count_annotations task.annotations)
                        ~completed:(Helper.count_annotated task.annotations)
                    ]
                ; div
                    ~a:[ class_ "bg-gray-700 p-4" ]
                    [ p
                        ~a:
                          [ class_
                              "text-xs leading-4 text-center font-medium \
                               text-gray-300 group-hover:text-gray-200 \
                               transition ease-in-out duration-150"
                          ]
                        [ span [ txt "\194\169 2020 Sapiens Labs" ] ]
                    ]
                ]
            ]
        ]
    ; div
        ~a:[ class_ "flex flex-col w-0 flex-1 overflow-hidden" ]
        [ div
            ~a:[ class_ "md:hidden pl-1 pt-1 sm:pl-3 sm:pt-3" ]
            [ button
                ~a:
                  [ a_aria "label" [ "Open sidebar" ]
                  ; class_
                      "-ml-0.5 -mt-0.5 h-12 w-12 inline-flex items-center \
                       justify-center rounded-md text-gray-500 \
                       hover:text-gray-900 focus:outline-none \
                       focus:bg-gray-200 transition ease-in-out duration-150"
                  ; a_onclick open_menu
                  ]
                [ svg
                    ~a:
                      [ Tyxml.Svg.class_ "h-6 w-6"
                      ; Tyxml.Svg.a_fill `None
                      ; Tyxml.Svg.a_stroke `CurrentColor
                      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                      ]
                    [ Tyxml.Svg.path
                        ~a:
                          [ Tyxml.Svg.a_d "M4 6h16M4 12h16M4 18h16"
                          ; a_svg_custom "stroke-linecap" "round"
                          ; a_svg_custom "stroke-linejoin" "round"
                          ; a_svg_custom "stroke-width" "2"
                          ]
                        []
                    ]
                ]
            ]
        ; main
            ~a:
              [ class_ "flex-1 relative z-0 overflow-y-auto focus:outline-none"
              ]
            [ div
                ~a:[ class_ "pt-2 pb-6 md:py-6" ]
                [ div
                    ~a:[ class_ "max-w-7xl mx-auto px-4 sm:px-6 md:px-8" ]
                    [ div
                        ~a:[ class_ "py-4" ]
                        [ Tyxml_lwd.Html.div
                            ~a:[ class_ "bg-white shadow rounded-lg" ]
                            children
                        ]
                    ]
                ]
            ; div
                ~a:[ class_ "inset-0 flex items-end justify-center px-4 py-6" ]
                [ span
                    ~a:[ class_ "relative z-0 inline-flex shadow-sm" ]
                    [ button
                        ~a:
                          [ a_aria "label" [ "Previous" ]
                          ; class_
                              "relative inline-flex items-center px-6 py-6 \
                               rounded-l-md border border-gray-300 bg-white \
                               text-sm leading-5 font-medium text-gray-500 \
                               hover:text-gray-400 focus:z-10 \
                               focus:outline-none focus:border-blue-300 \
                               focus:ring-blue active:bg-gray-100 \
                               active:text-gray-500 transition ease-in-out \
                               duration-150"
                          ; a_button_type `Button
                          ; a_onclick (fun _ ->
                                on_previous ();
                                false)
                          ]
                        [ svg
                            ~a:
                              [ Tyxml.Svg.class_ "h-8 w-8"
                              ; Tyxml.Svg.a_fill `CurrentColor
                              ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                              ]
                            [ Tyxml.Svg.path
                                ~a:
                                  [ a_svg_custom "clip-rule" "evenodd"
                                  ; Tyxml.Svg.a_d
                                      "M12.707 5.293a1 1 0 010 1.414L9.414 \
                                       10l3.293 3.293a1 1 0 01-1.414 \
                                       1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 \
                                       011.414 0z"
                                  ; a_svg_custom "fill-rule" "evenodd"
                                  ]
                                []
                            ]
                        ]
                    ; button
                        ~a:
                          [ a_aria "label" [ "Validate" ]
                          ; class_
                              "-ml-px relative inline-flex items-center px-6 \
                               py-6 border border-gray-300 bg-white text-sm \
                               leading-5 font-medium text-gray-500 \
                               hover:text-gray-400 focus:z-10 \
                               focus:outline-none focus:border-blue-300 \
                               focus:ring-blue active:bg-gray-100 \
                               active:text-gray-500 transition ease-in-out \
                               duration-150"
                          ; a_button_type `Button
                          ; a_onclick (fun _ ->
                                on_validate ();
                                false)
                          ]
                        [ svg
                            ~a:
                              [ Tyxml.Svg.class_ "h-8 w-8"
                              ; Tyxml.Svg.a_fill `None
                              ; Tyxml.Svg.a_stroke `CurrentColor
                              ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                              ]
                            [ Tyxml.Svg.path
                                ~a:
                                  [ Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                  ; a_svg_custom "stroke-linecap" "round"
                                  ; a_svg_custom "stroke-linejoin" "round"
                                  ; a_svg_custom "stroke-width" "2"
                                  ]
                                []
                            ]
                        ]
                    ; button
                        ~a:
                          [ a_aria "label" [ "Next" ]
                          ; class_
                              "-ml-px relative inline-flex items-center px-6 \
                               py-6 rounded-r-md border border-gray-300 \
                               bg-white text-sm leading-5 font-medium \
                               text-gray-500 hover:text-gray-400 focus:z-10 \
                               focus:outline-none focus:border-blue-300 \
                               focus:ring-blue active:bg-gray-100 \
                               active:text-gray-500 transition ease-in-out \
                               duration-150"
                          ; a_button_type `Button
                          ; a_onclick (fun _ ->
                                on_next ();
                                false)
                          ]
                        [ svg
                            ~a:
                              [ Tyxml.Svg.class_ "h-8 w-8"
                              ; Tyxml.Svg.a_fill `CurrentColor
                              ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                              ]
                            [ Tyxml.Svg.path
                                ~a:
                                  [ a_svg_custom "clip-rule" "evenodd"
                                  ; Tyxml.Svg.a_d
                                      "M7.293 14.707a1 1 0 010-1.414L10.586 10 \
                                       7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 \
                                       0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                                  ; a_svg_custom "fill-rule" "evenodd"
                                  ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
