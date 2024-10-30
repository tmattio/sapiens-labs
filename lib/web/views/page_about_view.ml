let team () =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "bg-white" ] ]
    [ div
        ~a:[ a_class [ "mx-auto py-12 px-4 max-w-screen-xl sm:px-6 lg:px-8 lg:py-24" ] ]
        [ div
            ~a:[ a_class [ "space-y-12" ] ]
            [ div
                ~a:[ a_class [ "space-y-5 sm:space-y-4 md:max-w-xl lg:max-w-3xl xl:max-w-none" ] ]
                [ h2
                    ~a:[ a_class [ "text-3xl leading-9 font-extrabold tracking-tight sm:text-4xl" ] ]
                    [ txt "Our Team" ]
                ; p
                    ~a:[ a_class [ "text-xl leading-7 text-gray-500" ] ]
                    [ txt
                        "Odio nisi, lectus dis nulla. Ultrices maecenas vitae rutrum dolor ultricies donec risus \
                         sodales. Tempus quis et."
                    ]
                ]
            ; ul
                ~a:
                  [ a_class
                      [ "space-y-12 sm:grid sm:grid-cols-2 sm:gap-x-6 sm:gap-y-12 sm:space-y-0 lg:grid-cols-3 \
                         lg:gap-x-8"
                      ]
                  ]
                [ li
                    [ div
                        ~a:[ a_class [ "space-y-4" ] ]
                        [ div
                            ~a:[ a_class [ "relative pb-2/3" ] ]
                            [ img
                                ~src:
                                  "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=8&w=1024&h=1024&q=80"
                                ~alt:""
                                ~a:[ a_class [ "absolute object-cover h-full w-full shadow-lg rounded-lg" ] ]
                                ()
                            ]
                        ; div
                            ~a:[ a_class [ "space-y-2" ] ]
                            [ div
                                ~a:[ a_class [ "text-lg leading-6 font-medium space-y-1" ] ]
                                [ h4 [ txt "Thibaut Mattio" ]
                                ; p ~a:[ a_class [ "text-indigo-600" ] ] [ txt "Founder" ]
                                ]
                            ; ul
                                ~a:[ a_class [ "flex space-x-5" ] ]
                                [ li
                                    [ a
                                        ~a:
                                          [ a_href "https://twitter.com/des0ps"
                                          ; a_class
                                              [ "text-gray-400 hover:text-gray-500 transition ease-in-out duration-150"
                                              ]
                                          ]
                                        [ span ~a:[ a_class [ "sr-only" ] ] [ txt "Twitter" ]
                                        ; svg
                                            ~a:
                                              [ Tyxml.Svg.a_class [ "w-5 h-5" ]
                                              ; Tyxml.Svg.a_fill `CurrentColor
                                              ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                                              ]
                                            [ Tyxml.Svg.path
                                                ~a:
                                                  [ Tyxml.Svg.a_d
                                                      "M6.29 18.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 \
                                                       0-.355-.012-.53A8.348 8.348 0 0020 3.92a8.19 8.19 0 \
                                                       01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 \
                                                       01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 \
                                                       01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.073 4.073 0 01.8 \
                                                       7.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 \
                                                       01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 010 \
                                                       16.407a11.616 11.616 0 006.29 1.84"
                                                  ]
                                                []
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
    ]

let make () =
  let open Tyxml.Html in
  Layout.make
    ~title:"About · Sapiens"
    [ Marketing_navbar.make ()
    ; div
        ~a:[ a_class [ "bg-white" ] ]
        [ div
            ~a:[ a_class [ "max-w-screen-xl mx-auto pt-16 sm:pt-24 pb-8 px-4 sm:px-6 lg:px-8" ] ]
            [ div
                ~a:[ a_class [ "text-center" ] ]
                [ h1
                    ~a:[ a_class [ "text-base leading-6 font-semibold text-indigo-600 tracking-wide uppercase" ] ]
                    [ txt "About" ]
                ; p
                    ~a:
                      [ a_class
                          [ "mt-1 text-4xl leading-10 font-extrabold text-gray-900 sm:text-5xl sm:leading-none \
                             sm:tracking-tight lg:text-6xl"
                          ]
                      ]
                    [ txt "Who we are." ]
                ; p
                    ~a:[ a_class [ "max-w-xl mt-5 mx-auto text-xl leading-7 text-gray-500" ] ]
                    [ txt
                        "We believe machine learning should be a commodity, so we're doing our part to make it happen."
                    ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "py-8 xl:py-16 px-4 sm:px-6 lg:px-8 bg-white overflow-hidden" ] ]
        [ div
            ~a:[ a_class [ "max-w-max-content lg:max-w-7xl mx-auto" ] ]
            [ div
                ~a:[ a_class [ "relative" ] ]
                [ div
                    ~a:[ a_class [ "relative md:bg-white md:p-6" ] ]
                    [ div
                        ~a:[ a_class [ "lg:grid lg:grid-cols-2 lg:gap-6 mb-8" ] ]
                        [ div
                            ~a:[ a_class [ "prose prose-lg text-gray-500 mb-6 lg:max-w-none lg:mb-0" ] ]
                            [ p
                                [ txt
                                    "Ultrices ultricies a in odio consequat egestas rutrum. Ut vitae aliquam in ipsum. \
                                     Duis nullam placerat cursus risus ultrices nisi, vitae tellus in. Qui non fugiat \
                                     aut minus aut rerum. Perspiciatis iusto mollitia iste minima soluta id."
                                ]
                            ; p
                                [ txt
                                    "Erat pellentesque dictumst ligula porttitor risus eget et eget. Ultricies tellus \
                                     felis id dignissim eget. Est augue risus nulla ultrices congue nunc tortor. Eu \
                                     leo risus porta integer suspendisse sed sit ligula elit."
                                ]
                            ; ol
                                [ li [ txt "Integer varius imperdiet sed interdum felis cras in nec nunc." ]
                                ; li [ txt "Quam malesuada odio ut sit egestas. Elementum at porta vitae." ]
                                ]
                            ]
                        ; div
                            ~a:[ a_class [ "prose prose-lg text-gray-500" ] ]
                            [ p
                                [ txt
                                    "Erat pellentesque dictumst ligula porttitor risus eget et eget. Ultricies tellus \
                                     felis id dignissim eget. Est augue maecenas risus nulla ultrices congue nunc \
                                     tortor."
                                ]
                            ; p
                                [ txt
                                    "Eu leo risus porta integer suspendisse sed sit ligula elit. Elit egestas lacinia \
                                     sagittis pellentesque neque dignissim vulputate sodales. Diam sed mauris felis \
                                     risus, ultricies mauris netus tincidunt. Mauris sit eu ac tellus nibh non eget \
                                     sed accumsan. Viverra ac sed venenatis pulvinar elit. Cras diam quis tincidunt \
                                     lectus. Non mi vitae, scelerisque felis nisi, netus amet nisl."
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ; team ()
    ; Marketing_layout.footer ()
    ]
