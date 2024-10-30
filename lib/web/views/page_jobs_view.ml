let make () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Jobs · Sapiens"
    [ Marketing_navbar.make ()
    ; div
        ~a:[ a_class [ "bg-white" ] ]
        [ div
            ~a:[ a_class [ "max-w-screen-xl mx-auto pt-16 sm:pt-24 pb-8 px-4 sm:px-6 lg:px-8" ] ]
            [ div
                ~a:[ a_class [ "text-center" ] ]
                [ h1
                    ~a:[ a_class [ "text-base leading-6 font-semibold text-indigo-600 tracking-wide uppercase" ] ]
                    [ txt "Jobs" ]
                ; p
                    ~a:
                      [ a_class
                          [ "mt-1 text-4xl leading-10 font-extrabold text-gray-900 sm:text-5xl sm:leading-none \
                             sm:tracking-tight lg:text-6xl"
                          ]
                      ]
                    [ txt "Work at Sapiens Labs." ]
                ; p
                    ~a:[ a_class [ "max-w-xl mt-5 mx-auto text-xl leading-7 text-gray-500" ] ]
                    [ txt "We are a small team with a strong focus on technology." ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "relative px-4 sm:px-6 lg:px-8 py-16 lg:py-32" ] ]
        [ div
            ~a:[ a_class [ "text-lg max-w-prose mx-auto mb-6" ] ]
            [ p
                ~a:[ a_class [ "text-xl text-gray-500 leading-8" ] ]
                [ txt "We don't have any opening at the moment, we'll post here when we have!" ]
            ]
        ]
    ; Marketing_layout.footer ()
    ]
