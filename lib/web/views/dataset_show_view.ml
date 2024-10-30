let preview_image (v : Sapiens_backend.Dataset.Datapoint.Image.Feature.t) =
  let open Tyxml.Html in
  let url = Sapiens_backend.Dataset.Datapoint.Image.Feature.url v in
  a
    ~a:[ a_href url; a_class [ "no-underline font-bold text-blue-500 hover:text-blue-400" ]; a_target "_blank" ]
    [ img ~src:url ~alt:url ~a:[ a_class [ "block h-8 w-auto" ] ] () ]

let preview_image_seq (v : Sapiens_backend.Dataset.Datapoint.Image.Feature.t list) =
  let open Tyxml.Html in
  span
    (ListLabels.map v ~f:(fun v ->
         let url = Sapiens_backend.Dataset.Datapoint.Image.Feature.url v in
         a
           ~a:
             [ a_href url
             ; a_class [ "no-underline font-bold text-blue-500 hover:text-blue-400 mr-2" ]
             ; a_target "_blank"
             ]
           [ img ~src:url ~alt:url ~a:[ a_class [ "block h-8 w-auto" ] ] () ]))

let preview_text (v : Sapiens_backend.Dataset.Datapoint.Text.Feature.t) =
  let open Tyxml.Html in
  let value = Sapiens_backend.Dataset.Datapoint.Text.Feature.value v in
  txt value

let preview_bbox (_v : Sapiens_backend.Dataset.Datapoint.Bbox.Feature.t) =
  let open Tyxml.Html in
  txt "TODO"

let preview_bbox_seq (_v : Sapiens_backend.Dataset.Datapoint.Bbox.Feature.t list) =
  let open Tyxml.Html in
  txt "TODO"

let preview_label (v : Sapiens_backend.Dataset.Datapoint.Label.Feature.t) =
  let open Sapiens_backend.Dataset.Datapoint in
  let open Tyxml.Html in
  let label = Label.Feature.value v in
  span
    ~a:
      [ a_class
          [ "inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium leading-5 bg-gray-100 text-gray-800"
          ]
      ]
    [ txt label ]

let preview_label_seq (v : Sapiens_backend.Dataset.Datapoint.Label.Feature.t list) =
  let open Sapiens_backend.Dataset.Datapoint in
  let open Tyxml.Html in
  let labels = StringLabels.concat ~sep:", " (ListLabels.map v ~f:Label.Feature.value) in
  span
    ~a:
      [ a_class
          [ "inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium leading-5 bg-gray-100 text-gray-800"
          ]
      ]
    [ txt labels ]

let preview_tokens (_v : Sapiens_backend.Dataset.Datapoint.Tokens.Feature.t) =
  let open Tyxml.Html in
  txt "TODO"

let preview_entity (_v : Sapiens_backend.Dataset.Datapoint.Entity.Feature.t) =
  let open Tyxml.Html in
  txt "TODO"

let preview_entity_seq (_v : Sapiens_backend.Dataset.Datapoint.Entity.Feature.t list) =
  let open Tyxml.Html in
  txt "TODO"

let preview_number (v : Sapiens_backend.Dataset.Datapoint.Number.Feature.t) =
  let open Tyxml.Html in
  let number = v |> Sapiens_backend.Dataset.Datapoint.Number.Feature.value |> string_of_float in
  span [ txt number ]

let preview_number_seq (v : Sapiens_backend.Dataset.Datapoint.Number.Feature.t list) =
  let open Tyxml.Html in
  let numbers =
    StringLabels.concat
      ~sep:", "
      (ListLabels.map v ~f:(fun x -> Sapiens_backend.Dataset.Datapoint.Number.Feature.value x |> string_of_float))
  in
  span [ txt numbers ]

let preview_datapoint_table_row
    ~(definitions : Sapiens_backend.Dataset.Datapoint.definition list) (datapoint : Sapiens_backend.Dataset.Datapoint.t)
  =
  let open Tyxml.Html in
  tr
    (ListLabels.map definitions ~f:(fun feature_definition ->
         let datapoint_opt =
           ListLabels.find_opt datapoint.features ~f:(fun feature ->
               Sapiens_backend.Dataset.Datapoint.definition_id_of_feature feature
               = Sapiens_backend.Dataset.Datapoint.id_of_definition feature_definition)
         in
         td
           ~a:
             [ a_class
                 [ "px-6 py-4 whitespace-nowrap border-b border-gray-200 text-sm leading-5 font-medium text-gray-900" ]
             ]
           [ (match datapoint_opt with
             | None ->
               txt ""
             | Some (Image v) ->
               preview_image v.feature
             | Some (Image_seq v) ->
               preview_image_seq v.feature
             | Some (Text v) ->
               preview_text v.feature
             | Some (Bbox v) ->
               preview_bbox v.feature
             | Some (Bbox_seq v) ->
               preview_bbox_seq v.feature
             | Some (Label v) ->
               preview_label v.feature
             | Some (Label_seq v) ->
               preview_label_seq v.feature
             | Some (Tokens v) ->
               preview_tokens v.feature
             | Some (Number v) ->
               preview_number v.feature
             | Some (Number_seq v) ->
               preview_number_seq v.feature
             | Some (Entity v) ->
               preview_entity v.feature
             | Some (Entity_seq v) ->
               preview_entity_seq v.feature)
           ]))

let preview_table
    ~(definitions : Sapiens_backend.Dataset.Datapoint.definition list)
    ~(datapoints : Sapiens_backend.Dataset.Datapoint.t list)
    ()
  =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "flex flex-col" ] ]
    [ div
        ~a:[ a_class [ "-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8" ] ]
        [ div
            ~a:[ a_class [ "py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8" ] ]
            [ div
                ~a:[ a_class [ "shadow overflow-hidden border-b border-gray-200 sm:rounded-lg" ] ]
                [ table
                    ~a:[ a_class [ "min-w-full divide-y divide-gray-200" ] ]
                    ~thead:
                      (thead
                         [ tr
                             (ListLabels.map definitions ~f:(fun el ->
                                  let feature_name =
                                    el.Sapiens_backend.Dataset.Datapoint.feature_name
                                    |> Sapiens_backend.Dataset.Datapoint.Feature_name.to_string
                                  in
                                  th
                                    ~a:
                                      [ a_class
                                          [ "px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 \
                                             font-medium text-gray-500 uppercase tracking-wider"
                                          ]
                                      ]
                                    [ txt feature_name ]))
                         ])
                    (ListLabels.map datapoints ~f:(fun el -> preview_datapoint_table_row ~definitions el))
                ]
            ]
        ]
    ]

let datapoint_counts ~datapoint_count =
  let open Tyxml.Html in
  div
    ~a:[ a_class [ "mb-5 grid grid-cols-1 gap-5 sm:grid-cols-3" ] ]
    [ div
        ~a:[ a_class [ "bg-white overflow-hidden shadow rounded-lg" ] ]
        [ div
            ~a:[ a_class [ "px-4 py-5 sm:p-6" ] ]
            [ dl
                [ dt
                    ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-500 truncate" ] ]
                    [ txt "Total Datapoints" ]
                ; dd
                    ~a:[ a_class [ "mt-1 text-3xl leading-9 font-semibold text-gray-900" ] ]
                    [ txt (string_of_int datapoint_count) ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "bg-white overflow-hidden shadow rounded-lg" ] ]
        [ div
            ~a:[ a_class [ "px-4 py-5 sm:p-6" ] ]
            [ dl
                [ dt ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-500 truncate" ] ] [ txt "Train set" ]
                ; dd ~a:[ a_class [ "mt-1 text-3xl leading-9 font-semibold text-gray-900" ] ] [ txt "100%" ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "bg-white overflow-hidden shadow rounded-lg" ] ]
        [ div
            ~a:[ a_class [ "px-4 py-5 sm:p-6" ] ]
            [ dl
                [ dt ~a:[ a_class [ "text-sm leading-5 font-medium text-gray-500 truncate" ] ] [ txt "Test set" ]
                ; dd ~a:[ a_class [ "mt-1 text-3xl leading-9 font-semibold text-gray-900" ] ] [ txt "0%" ]
                ]
            ]
        ]
    ]

let make ~dataset ~definitions ~datapoints ~datapoint_count ~user ?alert () =
  let open Tyxml.Html in
  let is_dataset_empty = match datapoints with [] -> true | _ -> false in
  Dataset_layout.make
    ~title:"Dataset · Sapiens"
    ~dataset
    ~user
    ~active:Overview
    (if is_dataset_empty then
       [ (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
       ; Dataset_empty.make ~dataset
       ]
    else
      [ (match alert with Some alert -> div ~a:[ a_class [ "mt-8" ] ] [ Alert.make alert ] | None -> div [])
      ; div
          ~a:[ a_class [ "flex" ] ]
          [ div
              ~a:[ a_class [ "w-2/3" ] ]
              [ datapoint_counts ~datapoint_count; preview_table ~definitions ~datapoints () ]
          ; div
              ~a:[ a_class [ "w-1/3 pl-8" ] ]
              [ h3 ~a:[ a_class [ "text-md font-bold leading-5 text-gray-900" ] ] [ txt "About" ]
              ; dl
                  ([]
                  @ (match dataset.description with
                    | Some description ->
                      [ dt ~a:[ a_class [ "mt-4 text-sm leading-5 font-medium text-gray-500" ] ] [ txt "Description" ]
                      ; dd
                          ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-900" ] ]
                          [ txt (Sapiens_backend.Dataset.Dataset.Description.to_string description) ]
                      ]
                    | None ->
                      [ dt ~a:[ a_class [ "mt-4 text-sm leading-5 font-medium text-gray-500" ] ] [ txt "Description" ]
                      ; dd ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-900" ] ] [ txt "No description" ]
                      ])
                  @ (match dataset.homepage with
                    | Some homepage ->
                      let homepage = Sapiens_backend.Dataset.Dataset.Homepage.to_string homepage in
                      [ dt ~a:[ a_class [ "mt-4 text-sm leading-5 font-medium text-gray-500" ] ] [ txt "Homepage" ]
                      ; dd
                          ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-900" ] ]
                          [ a
                              ~a:
                                [ a_href homepage
                                ; a_class [ "no-underline font-bold text-blue-500 hover:text-blue-400" ]
                                ]
                              [ txt homepage ]
                          ]
                      ]
                    | None ->
                      [])
                  @
                  match dataset.citation with
                  | Some citation ->
                    [ dt ~a:[ a_class [ "mt-4 text-sm leading-5 font-medium text-gray-500" ] ] [ txt "Citation" ]
                    ; dd
                        ~a:[ a_class [ "mt-1 text-sm text-gray-900" ] ]
                        [ pre
                            ~a:
                              [ a_class
                                  [ "rounded-lg block scrollbar-none m-0 p-0 overflow-auto bg-gray-100 leading-normal" ]
                              ]
                            [ code
                                ~a:[ a_class [ "inline-block p-4 scrolling-touch subpixel-antialiased" ] ]
                                [ txt (Sapiens_backend.Dataset.Dataset.Citation.to_string citation) ]
                            ]
                        ]
                    ]
                  | None ->
                    [])
              ]
          ]
      ])
