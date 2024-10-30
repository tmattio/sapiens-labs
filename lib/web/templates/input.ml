open Tyxml.Html

let createElement
    ~id ?name ?label:l ?(show_label = true) ?placeholder:ph ?(type_ = `Text) ?(required = true) ?help ?hint ()
  =
  div
    [ (match hint with
      | Some hint ->
        div
          ~a:[ a_class [ "flex justify-between" ] ]
          [ label
              ~a:
                [ a_label_for id
                ; a_class
                    [ (if show_label then
                         "block text-sm font-medium text-gray-700"
                      else
                        "sr-only")
                    ]
                ]
              (match l with Some l -> [ txt l ] | None -> [])
          ; span ~a:[ a_class [ "text-sm text-gray-500" ] ] [ txt hint ]
          ]
      | None ->
        label
          ~a:
            [ a_label_for id
            ; a_class
                [ (if show_label then
                     "block text-sm font-medium text-gray-700"
                  else
                    "sr-only")
                ]
            ]
          (match l with Some l -> [ txt l ] | None -> []))
    ; div
        ~a:
          [ a_class
              [ ("relative rounded-md shadow-sm"
                ^
                if show_label then
                  " mt-1"
                else
                  "")
              ]
          ]
        [ input
            ~a:
              ([ a_id id
               ; a_input_type type_
               ; a_class
                   [ "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 \
                      rounded-md"
                   ]
               ]
              @ (match ph with Some ph -> [ a_placeholder ph ] | None -> [])
              @ (match name with Some name -> [ a_name name ] | None -> [])
              @ if required then [ a_required () ] else [])
            ()
        ]
    ; (match help with
      | Some help ->
        p ~a:[ a_class [ "mt-2 text-sm text-gray-500" ]; a_id (id ^ "-description") ] [ txt help ]
      | None ->
        div [])
    ]

let make ~id ?label ?name ?show_label ?placeholder ?type_ ?required ?help ?hint () =
  createElement ~id ?label ?name ?show_label ?placeholder ?type_ ?required ?help ?hint ()
