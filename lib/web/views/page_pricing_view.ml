let faq_question ~question ~answer ~id ?(is_first = false) () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  [ dt
      ~a:
        [ a_class [ (if is_first then "text-lg leading-7" else "mt-6 border-t border-gray-200 pt-6 text-lg leading-7") ]
        ]
      [ button
          ~a:
            [ a_custom "x-description" "Expand/collapse question button"
            ; a_custom "@click" (Printf.sprintf "openPanel = (openPanel === %d ? null : %d)" id id)
            ; a_class
                [ "text-left w-full flex justify-between items-start text-gray-400 focus:outline-none \
                   focus:text-gray-900"
                ]
            ; a_aria "expanded" [ Printf.sprintf "openPanel === %d" id ]
            ]
          [ span ~a:[ a_class [ "font-medium text-gray-900" ] ] [ txt question ]
          ; span
              ~a:[ a_class [ "ml-6 h-7 flex items-center" ] ]
              [ svg
                  ~a:
                    [ Tyxml.Svg.a_class [ "h-6 w-6 transform rotate-0" ]
                    ; a_svg_custom "x-description" "Expand/collapse icon, toggle classes based on question open state."
                    ; a_svg_custom "x-state:on" "Open"
                    ; a_svg_custom "x-state:off" "Closed"
                    ; a_svg_custom
                        ":class"
                        (Printf.sprintf "{ '-rotate-180': openPanel === %d, 'rotate-0': !(openPanel === %d) }" id id)
                    ; Tyxml.Svg.a_fill `None
                    ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                    ; Tyxml.Svg.a_stroke `CurrentColor
                    ]
                  [ Tyxml.Svg.path
                      ~a:
                        [ a_svg_custom "stroke-linecap" "round"
                        ; a_svg_custom "stroke-linejoin" "round"
                        ; a_svg_custom "stroke-width" "2"
                        ; Tyxml.Svg.a_d "M19 9l-7 7-7-7"
                        ]
                      []
                  ]
              ]
          ]
      ]
  ; dd
      ~a:
        [ a_class [ "mt-2 pr-12" ]; a_custom "x-show" (Printf.sprintf "openPanel === %d" id); a_style "display: none;" ]
      [ p ~a:[ a_class [ "text-base leading-6 text-gray-500" ] ] [ txt answer ] ]
  ]

let faq () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  div
    ~a:[ a_class [ "bg-gray-50" ]; a_custom "x-data" "{ openPanel: null }" ]
    [ div
        ~a:[ a_class [ "max-w-screen-xl mx-auto py-12 px-4 sm:py-16 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "max-w-3xl mx-auto" ] ]
            [ h2
                ~a:
                  [ a_class [ "text-center text-3xl leading-9 font-extrabold text-gray-900 sm:text-4xl sm:leading-10" ]
                  ]
                [ txt "Frequently asked questions" ]
            ; div
                ~a:[ a_class [ "mt-6 border-t-2 border-gray-200 pt-6" ] ]
                [ dl
                    (faq_question
                       ~question:"Are prices listed only in US dollars?"
                       ~answer:"Yes, all prices shown are in US dollars."
                       ~id:1
                       ~is_first:true
                       ()
                    @ faq_question
                        ~question:"How long will Sapiens be free for public datasets?"
                        ~answer:"Forever! We believe in open data, so we'll always support people who share their data."
                        ~id:2
                        ())
                ]
            ]
        ]
    ]

let testimonial () =
  let open Tyxml.Html in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  section
    ~a:[ a_class [ "py-12 bg-white overflow-hidden md:py-20" ] ]
    [ div
        ~a:[ a_class [ "relative max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "relative" ] ]
            [ svg
                ~a:
                  [ Tyxml.Svg.a_class [ "mx-auto h-10" ]
                  ; Tyxml.Svg.a_fill `None
                  ; Tyxml.Svg.a_viewBox (0., 0., 180., 40.)
                  ]
                [ Tyxml.Svg.path
                    ~a:
                      [ Tyxml.Svg.a_fill (`Color ("#2D3748", None))
                      ; Tyxml.Svg.a_d
                          "M59.267 32.642h3.718L66.087 21.7l3.126 10.94h3.718l4.642-16.576h-3.434l-3.173 \
                           12.29-3.481-12.29H64.69l-3.457 12.29-3.174-12.29h-3.433l4.641 16.576zM83.551 32.973c3.481 0 \
                           6.276-2.723 6.276-6.252 0-3.528-2.794-6.252-6.276-6.252-3.48 0-6.252 2.724-6.252 6.252 0 \
                           3.529 2.771 6.252 6.252 6.252zm0-2.984c-1.8 0-3.197-1.35-3.197-3.268 0-1.918 1.398-3.268 \
                           3.197-3.268 1.824 0 3.221 1.35 3.221 3.268 0 1.918-1.397 3.268-3.22 3.268zM95.031 \
                           22.837v-2.036h-3.055v11.84h3.055v-5.66c0-2.486 2.013-3.196 3.6-3.007v-3.41c-1.492 \
                           0-2.984.663-3.6 2.273zM111.334 32.642l-4.902-5.992 4.76-5.85h-3.647l-4.073 \
                           5.21v-9.946h-3.055v16.578h3.055v-5.376l4.31 5.376h3.552z"
                      ]
                    []
                ; Tyxml.Svg.path
                    ~a:
                      [ Tyxml.Svg.a_fill (`Color ("#5850EC", None))
                      ; a_svg_custom "fill-rule" "evenodd"
                      ; Tyxml.Svg.a_d
                          "M42.342 17.45l-7.596-4.385v20.371h8.88v1.974H.21v-1.974h3.947v-12.55l-3.678.92L0 \
                           19.89l20.81-5.202h3.08a9.421 9.421 0 00-.67 2.525l-.477 3.922 \
                           5.096-2.942v15.243h4.933v-20.37l-7.594 4.385a7.402 7.402 0 012.531-4.736h-4.064a7.39 7.39 0 \
                           016.557-2.933l-5.517-3.186a7.388 7.388 0 016.607.397 7.366 7.366 0 012.468 2.316 7.363 \
                           7.363 0 012.467-2.316 7.39 7.39 0 016.608-.397l-5.518 3.186a7.389 7.389 0 016.558 \
                           2.933h-4.066a7.399 7.399 0 012.533 4.735zm-18.45 6.119h-5.92v9.867h5.92v-9.867zm-10.854 \
                           1.973a1.974 1.974 0 11-3.947 0 1.974 1.974 0 013.947 0z"
                      ; a_svg_custom "clip-rule" "evenodd"
                      ]
                    []
                ; Tyxml.Svg.path
                    ~a:
                      [ Tyxml.Svg.a_fill (`Color ("#5850EC", None))
                      ; Tyxml.Svg.a_d
                          "M118.495 32.973c2.321 0 4.334-1.232 5.352-3.079l-2.652-1.515c-.474.97-1.492 1.563-2.723 \
                           1.563-1.824 0-3.174-1.35-3.174-3.221 0-1.895 1.35-3.244 3.174-3.244 1.207 0 2.226.615 2.699 \
                           1.586l2.629-1.54c-.971-1.823-2.984-3.054-5.305-3.054-3.599 0-6.252 2.723-6.252 6.252 0 \
                           3.528 2.653 6.252 6.252 6.252zM134.277 20.8v1.398c-.853-1.066-2.131-1.729-3.86-1.729-3.15 \
                           0-5.755 2.723-5.755 6.252 0 3.528 2.605 6.252 5.755 6.252 1.729 0 3.007-.663 \
                           3.86-1.729v1.397h3.055v-11.84h-3.055zm-3.292 9.26c-1.871 0-3.268-1.35-3.268-3.34 0-1.988 \
                           1.397-3.338 3.268-3.338 1.895 0 3.292 1.35 3.292 3.339 0 1.99-1.397 3.339-3.292 \
                           3.339zM146.875 23.737v-2.936h-2.676v-3.316l-3.055.924V20.8h-2.06v2.936h2.06v4.926c0 3.197 \
                           1.445 4.452 5.731 3.978v-2.77c-1.752.094-2.676.07-2.676-1.208v-4.926h2.676zM150.544 \
                           19.38c1.042 0 1.895-.853 1.895-1.871s-.853-1.895-1.895-1.895c-1.018 0-1.87.877-1.87 \
                           1.895a1.89 1.89 0 001.87 1.87zm-1.515 13.261h3.055v-11.84h-3.055v11.84zM160.516 \
                           32.973c3.481 0 6.276-2.724 6.276-6.252 0-3.529-2.795-6.252-6.276-6.252s-6.252 2.723-6.252 \
                           6.252c0 3.528 2.771 6.252 6.252 6.252zm0-2.984c-1.8 0-3.197-1.35-3.197-3.268 0-1.918 \
                           1.397-3.268 3.197-3.268 1.824 0 3.221 1.35 3.221 3.268 0 1.918-1.397 3.268-3.221 \
                           3.268zM175.524 20.469c-1.586 0-2.818.592-3.528 1.658V20.8h-3.055v11.84h3.055v-6.394c0-2.06 \
                           1.113-2.936 2.605-2.936 1.373 0 2.344.829 2.344 \
                           2.439v6.891H180v-7.27c0-3.15-1.966-4.902-4.476-4.902z"
                      ]
                    []
                ]
            ; blockquote
                ~a:[ a_class [ "mt-8" ] ]
                [ div
                    ~a:[ a_class [ "max-w-3xl mx-auto text-center text-2xl leading-9 font-medium text-gray-900" ] ]
                    [ p
                        [ txt
                            "\226\128\156Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo expedita \
                             voluptas culpa sapiente alias molestiae. Numquam corrupti in laborum sed rerum et \
                             corporis.\226\128\157"
                        ]
                    ]
                ; footer
                    ~a:[ a_class [ "mt-8" ] ]
                    [ div
                        ~a:[ a_class [ "md:flex md:items-center md:justify-center" ] ]
                        [ div
                            ~a:[ a_class [ "md:flex-shrink-0" ] ]
                            [ img
                                ~src:
                                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                ~alt:""
                                ~a:[ a_class [ "mx-auto h-10 w-10 rounded-full" ] ]
                                ()
                            ]
                        ; div
                            ~a:[ a_class [ "mt-3 text-center md:mt-0 md:ml-4 md:flex md:items-center" ] ]
                            [ div
                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                                [ txt "Judith Black" ]
                            ; svg
                                ~a:
                                  [ Tyxml.Svg.a_class [ "hidden md:block mx-1 h-5 w-5 text-indigo-600" ]
                                  ; Tyxml.Svg.a_fill `CurrentColor
                                  ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                                  ]
                                [ Tyxml.Svg.path ~a:[ Tyxml.Svg.a_d "M11 0h3L9 20H6l5-20z" ] [] ]
                            ; div
                                ~a:[ a_class [ "text-base leading-6 font-medium text-gray-500" ] ]
                                [ txt "CEO, Workcation" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let make () =
  let open Tyxml.Html in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  Layout.make
    ~title:"Pricing · Sapiens"
    [ Marketing_navbar.make ()
    ; div
        ~a:[ a_class [ "bg-gray-800" ] ]
        [ div
            ~a:[ a_class [ "pt-12 sm:pt-16 lg:pt-24" ] ]
            [ div
                ~a:[ a_class [ "max-w-screen-xl mx-auto text-center px-4 sm:px-6 lg:px-8" ] ]
                [ div
                    ~a:[ a_class [ "max-w-3xl mx-auto lg:max-w-none" ] ]
                    [ h1
                        ~a:
                          [ a_class
                              [ "mt-2 text-3xl leading-9 font-extrabold text-white sm:text-4xl sm:leading-10 \
                                 lg:text-5xl lg:leading-none"
                              ]
                          ]
                        [ txt "The right price for you, whoever you are" ]
                    ; p
                        ~a:[ a_class [ "mt-2 text-xl leading-7 text-gray-300" ] ]
                        [ txt
                            "Lorem ipsum dolor, sit amet consectetur adipisicing elit. Harum sequi unde repudiandae \
                             natus."
                        ]
                    ]
                ]
            ]
        ; div
            ~a:[ a_class [ "mt-8 pb-12 bg-white sm:mt-12 sm:pb-16 lg:mt-16 lg:pb-24" ] ]
            [ div
                ~a:[ a_class [ "relative" ] ]
                [ div ~a:[ a_class [ "absolute inset-0 h-3/4 bg-gray-800" ] ] []
                ; div
                    ~a:[ a_class [ "relative z-10 max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
                    [ div
                        ~a:[ a_class [ "max-w-md mx-auto lg:max-w-5xl lg:grid lg:grid-cols-2 lg:gap-5" ] ]
                        [ div
                            ~a:[ a_class [ "rounded-lg shadow-lg overflow-hidden" ] ]
                            [ div
                                ~a:[ a_class [ "px-6 py-8 bg-white sm:p-10 sm:pb-6" ] ]
                                [ div
                                    [ h3
                                        ~a:
                                          [ a_class
                                              [ "inline-flex px-4 py-1 rounded-full text-sm leading-5 font-semibold \
                                                 tracking-wide uppercase bg-indigo-100 text-indigo-600"
                                              ]
                                          ; a_id "tier-free"
                                          ]
                                        [ txt "Free" ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "mt-4 flex items-baseline text-6xl leading-none font-extrabold" ] ]
                                    [ txt "$0" ]
                                ; p
                                    ~a:[ a_class [ "mt-5 text-lg leading-7 text-gray-500" ] ]
                                    [ txt "Lorem ipsum dolor sit amet consectetur, adipisicing elit." ]
                                ]
                            ; div
                                ~a:[ a_class [ "px-6 pt-6 pb-8 bg-gray-50 sm:p-10 sm:pt-6" ] ]
                                [ ul
                                    [ li
                                        ~a:[ a_class [ "flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Unlimited public datasets" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Analyze 1,000 documents per month" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Annotate your datasets" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Train 1 model per month" ]
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "mt-6 rounded-md shadow" ] ]
                                    [ a
                                        ~a:
                                          [ a_href "#"
                                          ; a_class
                                              [ "flex items-center justify-center px-5 py-3 border border-transparent \
                                                 text-base leading-6 font-medium rounded-md text-white bg-gray-900 \
                                                 hover:bg-gray-800 focus:outline-none focus:ring transition \
                                                 duration-150 ease-in-out"
                                              ]
                                          ; a_aria "describedby" [ "tier-standard" ]
                                          ]
                                        [ txt "Get started" ]
                                    ]
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "mt-4 rounded-lg shadow-lg overflow-hidden lg:mt-0" ] ]
                            [ div
                                ~a:[ a_class [ "px-6 py-8 bg-white sm:p-10 sm:pb-6" ] ]
                                [ div
                                    [ h3
                                        ~a:
                                          [ a_class
                                              [ "inline-flex px-4 py-1 rounded-full text-sm leading-5 font-semibold \
                                                 tracking-wide uppercase bg-indigo-100 text-indigo-600"
                                              ]
                                          ; a_id "tier-enterprise"
                                          ]
                                        [ txt "Enterprise" ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "mt-4 flex items-baseline text-6xl leading-none font-extrabold" ] ]
                                    [ txt "$299"
                                    ; span
                                        ~a:[ a_class [ "ml-1 text-2xl leading-8 font-medium text-gray-500" ] ]
                                        [ txt "/mo" ]
                                    ]
                                ; p
                                    ~a:[ a_class [ "mt-5 text-lg leading-7 text-gray-500" ] ]
                                    [ txt "Lorem ipsum dolor sit amet consectetur, adipisicing elit." ]
                                ]
                            ; div
                                ~a:[ a_class [ "px-6 pt-6 pb-8 bg-gray-50 sm:p-10 sm:pt-6" ] ]
                                [ ul
                                    [ li
                                        ~a:[ a_class [ "flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Unlimited private datasets" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Analyze 100,000 documents per month" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Annotate your datasets or outsource it" ]
                                        ]
                                    ; li
                                        ~a:[ a_class [ "mt-4 flex items-start" ] ]
                                        [ div
                                            ~a:[ a_class [ "flex-shrink-0" ] ]
                                            [ svg
                                                ~a:
                                                  [ Tyxml.Svg.a_class [ "h-6 w-6 text-green-500" ]
                                                  ; Tyxml.Svg.a_fill `None
                                                  ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                                                  ; Tyxml.Svg.a_stroke `CurrentColor
                                                  ]
                                                [ Tyxml.Svg.path
                                                    ~a:
                                                      [ a_svg_custom "stroke-linecap" "round"
                                                      ; a_svg_custom "stroke-linejoin" "round"
                                                      ; a_svg_custom "stroke-width" "2"
                                                      ; Tyxml.Svg.a_d "M5 13l4 4L19 7"
                                                      ]
                                                    []
                                                ]
                                            ]
                                        ; p
                                            ~a:[ a_class [ "ml-3 text-base leading-6 text-gray-700" ] ]
                                            [ txt "Train 10 models per month" ]
                                        ]
                                    ]
                                ; div
                                    ~a:[ a_class [ "mt-6 rounded-md shadow" ] ]
                                    [ a
                                        ~a:
                                          [ a_href "#"
                                          ; a_class
                                              [ "flex items-center justify-center px-5 py-3 border border-transparent \
                                                 text-base leading-6 font-medium rounded-md text-white bg-gray-900 \
                                                 hover:bg-gray-800 focus:outline-none focus:ring transition \
                                                 duration-150 ease-in-out"
                                              ]
                                          ; a_aria "describedby" [ "tier-enterprise" ]
                                          ]
                                        [ txt "Get started" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ; testimonial ()
    ; faq ()
    ; Marketing_layout.footer ()
    ]
