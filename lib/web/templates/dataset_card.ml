open Tyxml.Html

module Preview = struct
  let createElement () =
    div
      ~a:[ a_class [ "flex flex-wrap -mb-3" ] ]
      [ div ~a:[ a_class [ "w-full mb-3 bg-gray-300 h-6" ] ] []
      ; div ~a:[ a_class [ "w-full mb-3 bg-gray-300 h-6" ] ] []
      ; div ~a:[ a_class [ "w-1/2 mb-3 bg-gray-300 h-6" ] ] []
      ]
end

let preview = Preview.createElement ()

let color_of_score score = if score < 60 then `purple else if score < 80 then `blue else `green

let letter_of_score score = if score < 60 then "C" else if score < 80 then "B" else "A"

let createElement ~name ?description ~score () =
  let score = max 0 (min 100 score) in
  let letter = letter_of_score score in
  let color = color_of_score score in
  Panel.make
    [ Panel.header [ txt name ]
    ; Panel.body
        [ preview
        ; div ~a:[ a_class [ "py-4" ] ] [ div ~a:[ a_class [ "border-t border-gray-200" ] ] [] ]
        ; (match description with
          | Some description ->
            p ~a:[ a_class [ "pb-1 text-gray-600" ] ] [ txt description ]
          | None ->
            div [])
        ; Progress_bar.make ~label:letter ~percentage:score ~color ()
        ; div
            ~a:[ a_class [ "flex -mx-2" ] ]
            [ div
                ~a:[ a_class [ "w-1/3 px-2 text-center" ] ]
                [ a
                    ~a:
                      [ a_href "/datasets/dummy"
                      ; a_class [ "text-sm text-gray-500 hover:text-gray-400 transition duration-150 ease-in-out" ]
                      ]
                    [ txt "View more" ]
                ]
            ]
        ]
    ]

let make = createElement
