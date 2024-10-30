module Preview = struct
  let createElement () =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "flex flex-wrap -mb-2" ] ]
      [ div ~a:[ a_class [ "w-full mb-2 bg-gray-300 h-4" ] ] []
      ; div ~a:[ a_class [ "w-full mb-2 bg-gray-300 h-4" ] ] []
      ; div ~a:[ a_class [ "w-1/2 mb-2 bg-gray-300 h-4" ] ] []
      ]
end

let preview = Preview.createElement ()

let color_of_score score = if score < 60 then `purple else if score < 80 then `blue else `green

let letter_of_score score = if score < 60 then "C" else if score < 80 then "B" else "A"

let card ~name ~id ~type_ ?description ~score () =
  let score = max 0 (min 100 score) in
  let letter = letter_of_score score in
  let color = color_of_score score in
  let open Tyxml.Html in
  a
    ~a:
      [ a_href ("/datasets/" ^ string_of_int id)
      ; a_class [ "block bg-white hover:bg-gray-50 cursor-pointer rounded-lg shadow" ]
      ]
    [ div
        ~a:[ a_class [ "w-full flex flex-col p-6 space-y-6" ] ]
        [ preview
        ; div
            ~a:[ a_class [ "w-full flex items-center justify-between space-x-6" ] ]
            [ div
                ~a:[ a_class [ "flex-1 truncate" ] ]
                [ div
                    ~a:[ a_class [ "flex items-center space-x-3" ] ]
                    [ h3 ~a:[ a_class [ "text-gray-900 text-sm leading-5 font-medium truncate" ] ] [ txt name ]
                    ; span
                        ~a:
                          [ a_class
                              [ "flex-shrink-0 inline-block px-2 py-0.5 text-teal-800 text-xs leading-4 font-medium \
                                 bg-teal-100 rounded-full"
                              ]
                          ]
                        [ txt type_ ]
                    ]
                ; (match description with
                  | Some description ->
                    p ~a:[ a_class [ "mt-1 text-gray-500 text-sm leading-5 truncate" ] ] [ txt description ]
                  | None ->
                    div [])
                ]
            ]
        ; Progress_bar.make ~label:letter ~percentage:score ~color ()
        ]
    ]

let createElement ~datasets () =
  let open Tyxml.Html in
  ul
    ~a:[ a_class [ "grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3" ] ]
    (ListLabels.map datasets ~f:(fun (dataset : Sapiens_backend.Dataset.Dataset.t) ->
         li
           ~a:[ a_class [ "col-span-1" ] ]
           [ card
               ~name:(Sapiens_backend.Dataset.Dataset.Name.to_string dataset.name)
               ~id:dataset.id
               ?description:(Option.map Sapiens_backend.Dataset.Dataset.Description.to_string dataset.description)
               ~type_:"Image"
               ~score:90
               ()
           ]))

let make datasets = createElement ~datasets ()
