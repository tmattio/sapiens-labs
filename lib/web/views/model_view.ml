module Empty_model = struct
  let make ~model =
    let open Tyxml.Html in
    div
      ~a:[ a_class [ "mx-auto max-w-lg" ] ]
      [ div
          [ div
              ~a:[ a_class [ "mx-auto flex items-center justify-center" ] ]
              [ img ~src:"/undraw_empty_xct9.svg" ~alt:"Empty model" () ]
          ; div
              ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
              [ h3
                  ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                  [ txt "Your model is emtpy" ]
              ; div
                  ~a:[ a_class [ "mt-2" ] ]
                  [ p
                      ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                      [ txt "You can upload a source to your model to preview it and see it the analytics result." ]
                  ]
              ]
          ]
      ; div
          ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
          [ span
              ~a:[ a_class [ "max-w-md mx-auto flex w-full rounded-md shadow-sm" ] ]
              [ a
                  ~a:
                    [ a_href ("/models/" ^ string_of_int model.Sapiens_backend.Model.Model.id ^ "/settings/sources")
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
end

module Model_layout = struct
  let make ~title:title_ ~model ~user children =
    let open Tyxml.Html in
    let model_name = model.Sapiens_backend.Model.Model.name |> Sapiens_backend.Model.Model.Name.to_string in
    let model_description = Option.map Sapiens_backend.Model.Model.Description.to_string model.description in
    Layout.make
      ~title:title_
      [ Layout.navbar ~user ()
      ; header
          ~a:[ a_class [ "bg-white shadow-sm" ] ]
          [ div
              ~a:[ a_class [ "max-w-7xl mx-auto pt-4 px-4 sm:px-6 lg:px-8" ] ]
              [ div
                  ~a:[ a_class [ "md:flex md:items-center md:justify-between" ] ]
                  [ div
                      ~a:[ a_class [ "flex-1 min-w-0" ] ]
                      [ h1
                          ~a:
                            [ a_class
                                [ "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate" ]
                            ]
                          [ txt model_name ]
                      ; (match model_description with
                        | Some model_description ->
                          p
                            ~a:[ a_class [ "mt-1 max-w-2xl text-sm leading-5 text-gray-500" ] ]
                            [ txt model_description ]
                        | None ->
                          div [])
                      ]
                  ; div
                      ~a:[ a_class [ "mt-4 flex md:mt-0 md:ml-4" ] ]
                      [ span
                          ~a:[ a_class [ "shadow-sm rounded-md" ] ]
                          [ button
                              ~a:
                                [ a_button_type `Button
                                ; a_class
                                    [ "inline-flex items-center px-4 py-2 border border-gray-300 text-sm leading-5 \
                                       font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 \
                                       focus:outline-none focus:ring-blue focus:border-blue-300 active:text-gray-800 \
                                       active:bg-gray-50 transition duration-150 ease-in-out"
                                    ]
                                ]
                              [ txt "Download" ]
                          ]
                      ; span
                          ~a:[ a_class [ "ml-3 shadow-sm rounded-md" ] ]
                          [ a
                              ~a:
                                [ a_href ("/models/" ^ string_of_int model.id ^ "/settings/sources")
                                ; a_class
                                    [ "inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 \
                                       font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                                       focus:outline-none focus:ring-indigo focus:border-indigo-700 \
                                       active:bg-indigo-700 transition duration-150 ease-in-out"
                                    ]
                                ]
                              [ txt "Upload" ]
                          ]
                      ]
                  ]
              ]
          ]
      ; Layout.content children
      ]
end

let index ~user ?alert ~models () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Sapiens"
    [ Layout.navbar ~user ~active:Models ()
    ; (match alert with Some alert -> div ~a:[ a_class [ "my-4" ] ] [ Alert.make alert ] | None -> div [])
    ; header
        ~a:[ a_class [ "pt-10 pb-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "md:flex md:items-center md:justify-between" ] ]
            [ div
                ~a:[ a_class [ "flex-1 min-w-0" ] ]
                [ h1
                    ~a:[ a_class [ "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate" ] ]
                    [ txt "Your models" ]
                ]
            ; (match models with
              | [] ->
                div []
              | _ ->
                div
                  ~a:[ a_class [ "mt-4 flex md:mt-0 md:ml-4" ] ]
                  [ span
                      ~a:[ a_class [ "shadow-sm rounded-md" ] ]
                      [ a
                          ~a:
                            [ a_href "/models/new"
                            ; a_class
                                [ "inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 \
                                   font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 \
                                   focus:outline-none focus:ring-indigo focus:border-indigo-700 active:bg-indigo-700 \
                                   transition duration-150 ease-in-out"
                                ]
                            ]
                          [ txt "Create a model" ]
                      ]
                  ])
            ]
        ]
    ; Layout.content
        [ (match models with
          | [] ->
            div
              ~a:[ a_class [ "mx-auto max-w-xl" ] ]
              [ div
                  [ div
                      ~a:[ a_class [ "mx-auto flex items-center justify-center" ] ]
                      [ img ~src:"/undraw_empty_street_sfxm.svg" ~alt:"No models" () ]
                  ; div
                      ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                      [ h3
                          ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                          [ txt "No model" ]
                      ; div
                          ~a:[ a_class [ "mt-2" ] ]
                          [ p
                              ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                              [ txt
                                  "You don't have any model. Once you have created your first model, it will be listed \
                                   here."
                              ]
                          ]
                      ]
                  ]
              ; div
                  ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
                  [ span
                      ~a:[ a_class [ "max-w-md mx-auto flex w-full rounded-md shadow-sm" ] ]
                      [ a
                          ~a:
                            [ a_href "/models/new"
                            ; a_class
                                [ "inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 \
                                   bg-indigo-600 text-base leading-6 font-medium text-white shadow-sm \
                                   hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:ring-indigo \
                                   transition ease-in-out duration-150 sm:text-sm sm:leading-5"
                                ]
                            ]
                          [ txt "Create your first model" ]
                      ]
                  ]
              ]
          | _ ->
            Model_table.make models)
        ]
    ]

let new_ ~user ?alert () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Create a model · Sapiens"
    [ Layout.navbar ~user ()
    ; Layout.page_title
        ~title:"Create a new model"
        ~subtitle:"A model contains various type of data. Once your model is created, you upload data to it."
        ()
    ; Layout.content
        [ (match alert with Some alert -> div ~a:[ a_class [ "mb-8" ] ] [ Alert.make alert ] | None -> div [])
        ; form
            ~a:[ a_action "/models"; a_method `Post ]
            [ div
                [ div
                    [ div
                        ~a:
                          [ a_class
                              [ "sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5"
                              ]
                          ]
                        [ label
                            ~a:
                              [ a_label_for "model-name"
                              ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                              ]
                            [ txt "Model Name" ]
                        ; div
                            ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                            [ input
                                ~a:
                                  [ a_id "model-name"
                                  ; a_name "name"
                                  ; a_input_type `Text
                                  ; a_required ()
                                  ; a_class
                                      [ "max-w-lg rounded-md shadow-sm py-3 px-4 block w-full shadow-sm \
                                         focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md"
                                      ]
                                  ]
                                ()
                            ; p
                                ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                                [ txt "A good model name is short and easy to remember." ]
                            ]
                        ]
                    ; div
                        ~a:
                          [ a_class
                              [ "mt-6 sm:mt-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t \
                                 sm:border-gray-200 sm:pt-5"
                              ]
                          ]
                        [ label
                            ~a:
                              [ a_label_for "description"
                              ; a_class [ "block text-sm font-medium leading-5 text-gray-700 sm:mt-px sm:pt-2" ]
                              ]
                            [ txt "Description" ]
                        ; div
                            ~a:[ a_class [ "mt-1 sm:mt-0 sm:col-span-2" ] ]
                            [ div
                                ~a:[ a_class [ "max-w-lg flex rounded-md shadow-sm" ] ]
                                [ textarea
                                    ~a:
                                      [ a_id "description"
                                      ; a_name "description"
                                      ; a_rows 3
                                      ; a_class
                                          [ "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full \
                                             sm:text-sm border-gray-300 rounded-md"
                                          ]
                                      ]
                                    (txt "")
                                ]
                            ; p
                                ~a:[ a_class [ "mt-2 text-sm text-gray-500" ] ]
                                [ txt "Write a few words to describe your model." ]
                            ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "mt-8 border-t border-gray-200 pt-5" ] ]
                [ div
                    ~a:[ a_class [ "flex justify-end" ] ]
                    [ span
                        ~a:[ a_class [ "ml-3 inline-flex rounded-md shadow-sm" ] ]
                        [ button
                            ~a:
                              [ a_button_type `Submit
                              ; a_class
                                  [ "inline-flex justify-center py-2 px-4 border border-transparent rounded-md \
                                     shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                     focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                  ]
                              ]
                            [ txt "Create model" ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let show ~model ~user ?alert:_ () =
  let is_model_empty = true in
  Model_layout.make
    ~title:"Model · Sapiens"
    ~model
    ~user
    (if is_model_empty then
       [ Empty_model.make ~model ]
    else
      [])

let edit ~user ~model ?alert:_ () =
  let open Tyxml.Html in
  Model_layout.make
    ~title:"Edit model · Sapiens"
    ~model
    ~user
    [ div
        ~a:[ a_class [ "w-full md:w-3/4 mt-6 md:mt-0 md:pl-6" ] ]
        [ h2 ~a:[ a_class [ "text-3xl pb-2 border-b mb-6" ] ] [ txt "Edit Model" ]; txt "Hello World" ]
    ]
