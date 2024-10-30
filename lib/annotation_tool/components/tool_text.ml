let make content =
  let open Tyxml.Html in
  let parts = String.split_on_char '\n' content in
  div
    ~a:[ class_ "prose-sm" ]
    (List.map (fun el -> [ txt el; br () ]) parts |> List.concat)
