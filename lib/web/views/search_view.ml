let search ~user ~datasets ?alert () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Search · Sapiens"
    [ Layout.navbar ~user ()
    ; (match alert with Some alert -> div ~a:[ a_class [ "my-4" ] ] [ Alert.make alert ] | None -> div [])
    ; header
        ~a:[ a_class [ "pt-10 pb-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "md:flex md:items-center md:justify-between" ] ]
            [ div
                ~a:[ a_class [ "flex-1 min-w-0" ] ]
                [ h1
                    ~a:[ a_class [ "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate" ] ]
                    [ txt "Datasets found" ]
                ]
            ]
        ]
    ; Layout.content [ Dataset_card_grid.make datasets ]
    ]
