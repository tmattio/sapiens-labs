let make =
  let open Tyxml.Html in
  div
    ~a:
      [ class_
          "gradient bg-gradient-to-br from-purple-600 to-blue-500 text-white \
           min-h-screen flex items-center"
      ]
    [ div
        ~a:[ class_ "container mx-auto p-4 flex flex-wrap items-center" ]
        [ div
            ~a:[ class_ "w-full md:w-5/12 text-center p-4" ]
            [ img
                ~src:"https://themichailov.com/img/not-found.svg"
                ~alt:"Not Found"
                ~a:[]
                ()
            ]
        ; div
            ~a:[ class_ "w-full md:w-7/12 text-center md:text-left p-4" ]
            [ div
                ~a:[ class_ "text-xl md:text-3xl font-medium mb-4" ]
                [ txt "Oops. An error occured" ]
            ; div
                ~a:[ class_ "text-lg mb-8" ]
                [ txt "We're sorry for the inconvenience." ]
            ; a
                ~a:[ a_href "#"; class_ "border border-white rounded p-4" ]
                [ txt "Go Home" ]
            ]
        ]
    ]
