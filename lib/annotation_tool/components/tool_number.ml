let event_input event =
  let open Js_of_ocaml in
  let target = Js.Opt.bind event##.target Dom_html.CoerceTo.input in
  match Js.Opt.to_option target with
  | None ->
    None
  | Some target ->
    Some (Js.to_string target##.value)

let make ~title:title_ ?min ?max ~on_change value =
  let open Tyxml.Html in
  let max_attr =
    max
    |> Option.map (fun x -> [ a_input_max (`Number (int_of_float x)) ])
    |> Option.value ~default:[]
  in
  let min_attr =
    min
    |> Option.map (fun x -> [ a_input_min (`Number (int_of_float x)) ])
    |> Option.value ~default:[]
  in
  let value_attr =
    value
    |> Option.map (fun x -> [ a_value (string_of_float x) ])
    |> Option.value ~default:[]
  in
  div
    [ div
        ~a:[ a_class [ "pb-2" ] ]
        [ h3
            ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
            [ txt title_ ]
        ]
    ; div
        ~a:[ a_class [ "mt-1 relative rounded-md shadow-sm" ] ]
        [ input
            ~a:
              ([ a_class
                   [ "py-3 px-4 block w-full shadow-sm focus:ring-indigo-500 \
                      focus:border-indigo-500 border-gray-300 rounded-md"
                   ]
               ; a_placeholder "Enter a value"
               ; a_input_type `Number
               ; a_onchange (fun event ->
                     (match
                        Option.bind (event_input event) int_of_string_opt
                      with
                     | None ->
                       ()
                     | Some v ->
                       on_change (float_of_int v));
                     true)
               ]
              @ min_attr
              @ max_attr
              @ value_attr)
            ()
        ]
    ]
