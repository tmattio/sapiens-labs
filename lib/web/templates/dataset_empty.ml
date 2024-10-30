let make ~dataset =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "mx-auto max-w-lg" ] ]
    [ div
        [ div
            ~a:[ a_class [ "mx-auto flex items-center justify-center" ] ]
            [ img ~src:"/undraw_empty_xct9.svg" ~alt:"Empty dataset" () ]
        ; div
            ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
            [ h3
                ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                [ txt "Your dataset is emtpy" ]
            ; div
                ~a:[ a_class [ "mt-2" ] ]
                [ p
                    ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                    [ txt "You can upload a source to your dataset to preview it and see it the analytics result." ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
        [ span
            ~a:[ a_class [ "max-w-md mx-auto flex w-full rounded-md shadow-sm" ] ]
            [ a
                ~a:
                  [ a_href
                      ("/datasets/" ^ string_of_int dataset.Sapiens_backend.Dataset.Dataset.id ^ "/settings/sources")
                  ; a_class
                      [ "inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 \
                         bg-indigo-600 text-base leading-6 font-medium text-white shadow-sm hover:bg-indigo-500 \
                         focus:outline-none focus:border-indigo-700 focus:ring-indigo transition ease-in-out \
                         duration-150 sm:text-sm sm:leading-5"
                      ]
                  ]
                [ txt "Upload a new source" ]
            ]
        ]
    ]
