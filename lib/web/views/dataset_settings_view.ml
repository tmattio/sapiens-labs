module Delete_dataset_modal = struct
  let make ~dataset children =
    let open Tyxml.Html in
    let a_custom x y = Xml.string_attrib x y |> to_attrib in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    div
      ~a:[ a_custom "x-data" "{ open: false }"; a_custom "@keydown.escape" "open = false" ]
      ([ div
           ~a:
             [ a_custom "x-show" "open"
             ; a_class
                 [ "fixed bottom-0 inset-x-0 px-4 pb-6 sm:inset-0 sm:p-0 sm:flex sm:items-center sm:justify-center" ]
             ]
           [ div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Background overlay, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0"
                 ; a_custom "x-transition:enter-end" "opacity-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100"
                 ; a_custom "x-transition:leave-end" "opacity-0"
                 ; a_class [ "fixed inset-0 transition-opacity" ]
                 ]
               [ div ~a:[ a_class [ "absolute inset-0 bg-gray-500 opacity-75" ] ] [] ]
           ; div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Modal panel, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_custom "x-transition:enter-end" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave-end" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_class
                     [ "bg-white rounded-lg px-4 pt-5 pb-4 overflow-hidden shadow-xl transform transition-all \
                        sm:max-w-lg sm:w-full sm:p-6"
                     ]
                 ; a_role [ "dialog" ]
                 ; a_aria "modal" [ "true" ]
                 ; a_aria "labelledby" [ "modal-headline" ]
                 ; a_custom "@click.away" "open = false"
                 ]
               [ div
                   [ div
                       ~a:[ a_class [ "mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100" ] ]
                       [ svg
                           ~a:
                             [ Tyxml.Svg.a_class [ "h-6 w-6 text-red-600" ]
                             ; Tyxml.Svg.a_fill `None
                             ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                             ; Tyxml.Svg.a_stroke `CurrentColor
                             ]
                           [ Tyxml.Svg.path
                               ~a:
                                 [ a_svg_custom "stroke-linecap" "round"
                                 ; a_svg_custom "stroke-linejoin" "round"
                                 ; a_svg_custom "stroke-width" "2"
                                 ; Tyxml.Svg.a_d
                                     "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 \
                                      4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                 ]
                               []
                           ]
                       ]
                   ; div
                       ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                       [ h3
                           ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                           [ txt "Are you sure?" ]
                       ; div
                           ~a:[ a_class [ "mt-2" ] ]
                           [ p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt "This will "; b [ txt "permanently delete this dataset." ] ]
                           ; p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt " The tasks, sources and all collaborators associations will be removed." ]
                           ]
                       ]
                   ]
               ; form
                   ~a:
                     [ a_action ("/datasets/" ^ string_of_int dataset.Sapiens_backend.Dataset.Dataset.id)
                     ; a_method `Post
                     ]
                   [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "DELETE" ] ()
                   ; div
                       ~a:[ a_class [ "mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense" ] ]
                       [ span
                           ~a:[ a_class [ "flex w-full rounded-md shadow-sm sm:col-start-2" ] ]
                           [ button
                               ~a:
                                 [ a_button_type `Submit
                                 ; a_class
                                     [ "inline-flex justify-center w-full rounded-md border border-transparent py-2 \
                                        px-4 border border-transparent rounded-md shadow-sm text-sm font-medium \
                                        text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-red-500"
                                     ]
                                 ]
                               [ txt "Delete this dataset" ]
                           ]
                       ; span
                           ~a:[ a_class [ "mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:col-start-1" ] ]
                           [ button
                               ~a:
                                 [ a_custom "@click" "open = false"
                                 ; a_button_type `Button
                                 ; a_class
                                     [ "inline-flex justify-center w-full flex justify-center py-2 px-4 border \
                                        border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 \
                                        bg-white hover:text-gray-500 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-blue-500"
                                     ]
                                 ]
                               [ txt "Cancel" ]
                           ]
                       ]
                   ]
               ]
           ]
       ]
      @ children)
end

module Transfer_dataset_modal = struct
  let make ~dataset children =
    let open Tyxml.Html in
    let a_custom x y = Xml.string_attrib x y |> to_attrib in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    div
      ~a:[ a_custom "x-data" "{ open: false }"; a_custom "@keydown.escape" "open = false" ]
      ([ div
           ~a:
             [ a_custom "x-show" "open"
             ; a_class
                 [ "fixed bottom-0 inset-x-0 px-4 pb-6 sm:inset-0 sm:p-0 sm:flex sm:items-center sm:justify-center" ]
             ]
           [ div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Background overlay, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0"
                 ; a_custom "x-transition:enter-end" "opacity-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100"
                 ; a_custom "x-transition:leave-end" "opacity-0"
                 ; a_class [ "fixed inset-0 transition-opacity" ]
                 ]
               [ div ~a:[ a_class [ "absolute inset-0 bg-gray-500 opacity-75" ] ] [] ]
           ; div
               ~a:
                 [ a_custom "x-show" "open"
                 ; a_custom "x-description" "Modal panel, show/hide based on modal state."
                 ; a_custom "x-transition:enter" "ease-out duration-300"
                 ; a_custom "x-transition:enter-start" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_custom "x-transition:enter-end" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave" "ease-in duration-200"
                 ; a_custom "x-transition:leave-start" "opacity-100 translate-y-0 sm:scale-100"
                 ; a_custom "x-transition:leave-end" "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                 ; a_class
                     [ "bg-white rounded-lg px-4 pt-5 pb-4 overflow-hidden shadow-xl transform transition-all \
                        sm:max-w-lg sm:w-full sm:p-6"
                     ]
                 ; a_role [ "dialog" ]
                 ; a_aria "modal" [ "true" ]
                 ; a_aria "labelledby" [ "modal-headline" ]
                 ; a_custom "@click.away" "open = false"
                 ]
               [ div
                   [ div
                       ~a:[ a_class [ "mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100" ] ]
                       [ svg
                           ~a:
                             [ Tyxml.Svg.a_class [ "h-6 w-6 text-red-600" ]
                             ; Tyxml.Svg.a_fill `None
                             ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                             ; Tyxml.Svg.a_stroke `CurrentColor
                             ]
                           [ Tyxml.Svg.path
                               ~a:
                                 [ a_svg_custom "stroke-linecap" "round"
                                 ; a_svg_custom "stroke-linejoin" "round"
                                 ; a_svg_custom "stroke-width" "2"
                                 ; Tyxml.Svg.a_d
                                     "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 \
                                      4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                 ]
                               []
                           ]
                       ]
                   ; div
                       ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                       [ h3
                           ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                           [ txt "Are you sure?" ]
                       ; div
                           ~a:[ a_class [ "mt-2" ] ]
                           [ p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt "We will send an transfer invitation to the user." ]
                           ; p
                               ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                               [ txt
                                   "If the user accepts, this dataset will be transfered to the user account and you \
                                    will loose access to it."
                               ]
                           ]
                       ]
                   ]
               ; form
                   ~a:
                     [ a_action ("/datasets/" ^ string_of_int dataset.Sapiens_backend.Dataset.Dataset.id ^ "/transfer")
                     ; a_method `Post
                     ]
                   [ div
                       ~a:[ a_class [ "mt-5 sm:mt-6" ] ]
                       [ Input.make
                           ~id:"email"
                           ~name:"email"
                           ~label:"Email of the new owner"
                           ~placeholder:"email@example.com"
                           ~type_:`Email
                           ~required:true
                           ()
                       ]
                   ; div
                       ~a:[ a_class [ "mt-5 sm:mt-6 sm:grid sm:grid-cols-2 sm:gap-3 sm:grid-flow-row-dense" ] ]
                       [ span
                           ~a:[ a_class [ "flex w-full rounded-md shadow-sm sm:col-start-2" ] ]
                           [ button
                               ~a:
                                 [ a_button_type `Submit
                                 ; a_class
                                     [ "inline-flex justify-center w-full rounded-md border border-transparent py-2 \
                                        px-4 border border-transparent rounded-md shadow-sm text-sm font-medium \
                                        text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-red-500"
                                     ]
                                 ]
                               [ txt "Send a transfer invitation" ]
                           ]
                       ; span
                           ~a:[ a_class [ "mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:col-start-1" ] ]
                           [ button
                               ~a:
                                 [ a_custom "@click" "open = false"
                                 ; a_button_type `Button
                                 ; a_class
                                     [ "inline-flex justify-center w-full flex justify-center py-2 px-4 border \
                                        border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 \
                                        bg-white hover:text-gray-500 focus:outline-none focus:ring-2 \
                                        focus:ring-offset-2 focus:ring-blue-500"
                                     ]
                                 ]
                               [ txt "Cancel" ]
                           ]
                       ]
                   ]
               ]
           ]
       ]
      @ children)
end

module Edit_layout = struct
  let icon_options =
    let open Tyxml.Html in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    svg
      ~a:
        [ Tyxml.Svg.a_class
            [ "flex-shrink-0 -ml-1 mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-500 group-focus:text-gray-600 \
               transition ease-in-out duration-150"
            ]
        ; Tyxml.Svg.a_fill `None
        ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
        ; Tyxml.Svg.a_stroke `CurrentColor
        ]
      [ Tyxml.Svg.path
          ~a:
            [ a_svg_custom "stroke-linecap" "round"
            ; a_svg_custom "stroke-linejoin" "round"
            ; a_svg_custom "stroke-width" "2"
            ; Tyxml.Svg.a_d
                "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 \
                 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
            ]
          []
      ]

  let icon_sources =
    let open Tyxml.Html in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    svg
      ~a:
        [ Tyxml.Svg.a_class
            [ "flex-shrink-0 -ml-1 mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-500 group-focus:text-gray-600 \
               transition ease-in-out duration-150"
            ]
        ; Tyxml.Svg.a_fill `None
        ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
        ; Tyxml.Svg.a_stroke `CurrentColor
        ]
      [ Tyxml.Svg.path
          ~a:
            [ a_svg_custom "stroke-linecap" "round"
            ; a_svg_custom "stroke-linejoin" "round"
            ; a_svg_custom "stroke-width" "2"
            ; Tyxml.Svg.a_d
                "M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 \
                 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
            ]
          []
      ]

  let icon_collaborators =
    let open Tyxml.Html in
    let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
    svg
      ~a:
        [ Tyxml.Svg.a_class
            [ "flex-shrink-0 -ml-1 mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-500 group-focus:text-gray-600 \
               transition ease-in-out duration-150"
            ]
        ; Tyxml.Svg.a_fill `None
        ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
        ; Tyxml.Svg.a_stroke `CurrentColor
        ]
      [ Tyxml.Svg.path
          ~a:
            [ a_svg_custom "stroke-linecap" "round"
            ; a_svg_custom "stroke-linejoin" "round"
            ; a_svg_custom "stroke-width" "2"
            ; Tyxml.Svg.a_d
                "M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 \
                 0 018 0z"
            ]
          []
      ]

  type nav_item =
    | Options
    | Collaborators
    | Sources

  let nav_items = [ Options; Sources; Collaborators ]

  let menu_item_of_nav = function Options -> "Options" | Sources -> "Sources" | Collaborators -> "Collaborators"

  let title_of_nav = function Options -> "Settings" | Sources -> "Sources" | Collaborators -> "Collaborators"

  let icon_of_nav = function Options -> icon_options | Sources -> icon_sources | Collaborators -> icon_collaborators

  let url_of_nav = function Options -> "" | Sources -> "/sources" | Collaborators -> "/collaborators"

  let make ~title:title_ ~dataset ~user ~active children =
    let open Tyxml.Html in
    Dataset_layout.make
      ~title:title_
      ~dataset
      ~user
      ~active:Settings
      [ div
          ~a:[ a_class [ "flex flex-wrap" ] ]
          [ nav
              ~a:[ a_class [ "w-full md:w-1/4" ] ]
              (ListLabels.map nav_items ~f:(fun item ->
                   a
                     ~a:
                       [ a_href ("/datasets/" ^ string_of_int dataset.id ^ "/settings" ^ url_of_nav item)
                       ; a_class
                           (if item = active then
                              [ "mt-1 first:mt-0 group flex items-center px-3 py-2 text-sm leading-5 font-medium \
                                 text-gray-900 rounded-md bg-gray-200 hover:text-gray-900 focus:outline-none \
                                 focus:bg-gray-300 transition ease-in-out duration-150"
                              ]
                           else
                             [ "mt-1 first:mt-0 group flex items-center px-3 py-2 text-sm leading-5 font-medium \
                                text-gray-600 rounded-md hover:text-gray-900 hover:bg-gray-50 focus:outline-none \
                                focus:text-gray-900 focus:bg-gray-200 transition ease-in-out duration-150"
                             ])
                       ]
                     [ icon_of_nav item; span ~a:[ a_class [ "truncate" ] ] [ txt (menu_item_of_nav item) ] ]))
          ; div
              ~a:[ a_class [ "w-full md:w-3/4 mt-6 md:mt-0 md:pl-6" ] ]
              ([ div
                   ~a:[ a_class [ "pb-5 border-b border-gray-200 mb-5" ] ]
                   [ h3 ~a:[ a_class [ "text-3xl leading-6 font-medium text-gray-900" ] ] [ txt (title_of_nav active) ]
                   ]
               ]
              @ children)
          ]
      ]
end

let edit ~user ~dataset ?alert:_ () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  Edit_layout.make
    ~title:"Edit dataset · Sapiens"
    ~dataset
    ~user
    ~active:Options
    [ div
        [ div
            [ h3 ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ] [ txt "Information" ]
            ; p
                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-500" ] ]
                [ txt "If your dataset is public, this information will be displayed publicly." ]
            ]
        ; div
            ~a:[ a_class [ "mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6" ] ]
            [ div
                ~a:[ a_class [ "sm:col-span-4" ] ]
                [ label
                    ~a:[ a_label_for "name"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                    [ txt "Name" ]
                ; div
                    ~a:[ a_class [ "mt-1 flex rounded-md shadow-sm" ] ]
                    [ input
                        ~a:
                          [ a_id "name"
                          ; a_input_type `Text
                          ; a_class
                              [ "flex-1 border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 \
                                 w-full sm:text-sm"
                              ]
                          ; a_value (Sapiens_backend.Dataset.Dataset.Name.to_string dataset.name)
                          ]
                        ()
                    ]
                ]
            ; div
                ~a:[ a_class [ "sm:col-span-6" ] ]
                [ label
                    ~a:[ a_label_for "description"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                    [ txt "Description" ]
                ; div
                    ~a:[ a_class [ "mt-1 rounded-md shadow-sm" ] ]
                    [ textarea
                        ~a:
                          [ a_id "description"
                          ; a_rows 3
                          ; a_class
                              [ "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm \
                                 border-gray-300 rounded-md"
                              ]
                          ]
                        (txt
                           (Option.map Sapiens_backend.Dataset.Dataset.Description.to_string dataset.description
                           |> Option.value ~default:""))
                    ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-8 flex justify-end" ] ]
        [ span
            ~a:[ a_class [ "inline-flex rounded-md shadow-sm" ] ]
            [ button
                ~a:
                  [ a_button_type `Submit
                  ; a_class
                      [ "inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm \
                         font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 \
                         focus:ring-offset-2 focus:ring-indigo-500"
                      ]
                  ]
                [ txt "Save" ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-8 border-t border-gray-200 pt-8" ] ]
        [ div
            [ h3 ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ] [ txt "Visibility" ]
            ; p ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-500" ] ] [ txt "Change who can view your dataset." ]
            ]
        ]
    ; div
        ~a:[ a_class [ "sm:col-span-6" ] ]
        [ div
            ~a:[ a_class [ "flex items-center" ] ]
            [ input
                ~a:
                  ([ a_id "visibility-public"
                   ; a_name "form-input push_notifications"
                   ; a_input_type `Radio
                   ; a_required ()
                   ; a_class [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300" ]
                   ]
                  @ if dataset.is_public then [ a_checked () ] else [])
                ()
            ; div
                ~a:[ a_class [ "pl-4 text-sm leading-5" ] ]
                [ label
                    ~a:[ a_label_for "visibility-public"; a_class [ "ml-3" ] ]
                    [ span ~a:[ a_class [ "block font-medium text-gray-700" ] ] [ txt "Public" ] ]
                ; p ~a:[ a_class [ "text-gray-500" ] ] [ txt "Your dataset will be visible to everyone." ]
                ]
            ]
        ; div
            ~a:[ a_class [ "mt-4 flex items-center" ] ]
            [ input
                ~a:
                  ([ a_id "visibility-private"
                   ; a_name "form-input push_notifications"
                   ; a_required ()
                   ; a_input_type `Radio
                   ; a_class [ "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300" ]
                   ]
                  @ if not dataset.is_public then [ a_checked () ] else [])
                ()
            ; div
                ~a:[ a_class [ "pl-4 text-sm leading-5" ] ]
                [ label
                    ~a:[ a_label_for "visibility-private"; a_class [ "ml-3" ] ]
                    [ span ~a:[ a_class [ "block text-sm leading-5 font-medium text-gray-700" ] ] [ txt "Private" ] ]
                ; p ~a:[ a_class [ "text-gray-500" ] ] [ txt "Only you will see your dataset." ]
                ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-8 flex justify-end" ] ]
        [ span
            ~a:[ a_class [ "inline-flex rounded-md shadow-sm" ] ]
            [ button
                ~a:
                  [ a_button_type `Submit
                  ; a_class
                      [ "inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm \
                         font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 \
                         focus:ring-offset-2 focus:ring-indigo-500"
                      ]
                  ]
                [ txt "Save" ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-8 border-t border-gray-200 pt-8" ] ]
        [ div
            [ h3 ~a:[ a_class [ "text-lg leading-6 font-medium text-gray-900" ] ] [ txt "Danger zone" ]
            ; p
                ~a:[ a_class [ "mt-1 text-sm leading-5 text-gray-500" ] ]
                [ txt "These actions are irreversible, be certain of what you are doing." ]
            ]
        ]
    ; div
        ~a:[ a_class [ "mt-8 bg-white shadow overflow-hidden sm:rounded-md" ] ]
        [ ul
            [ li
                [ div
                    ~a:[ a_class [ "sm:flex sm:items-start sm:justify-between px-4 py-4 sm:px-6" ] ]
                    [ div
                        [ h3
                            ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                            [ txt "Transfer ownership" ]
                        ; div
                            ~a:[ a_class [ "mt-2 max-w-xl text-sm leading-5 text-gray-500" ] ]
                            [ p [ txt "Transfer this dataset to another user." ] ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-5 sm:mt-0 sm:ml-6 sm:flex-shrink-0 sm:flex sm:items-center" ] ]
                        [ div
                            ~a:[ a_class [ "inline-flex rounded-md shadow-sm" ] ]
                            [ Transfer_dataset_modal.make
                                ~dataset
                                [ button
                                    ~a:
                                      [ a_custom "@click" "open = true"
                                      ; a_button_type `Button
                                      ; a_class
                                          [ "inline-flex items-center py-2 px-4 border border-transparent rounded-md \
                                             shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 \
                                             focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                                          ]
                                      ]
                                    [ txt "Transfer this dataset" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ; li
                ~a:[ a_class [ "border-t border-gray-200" ] ]
                [ div
                    ~a:[ a_class [ "sm:flex sm:items-start sm:justify-between px-4 py-4 sm:px-6" ] ]
                    [ div
                        [ h3
                            ~a:[ a_class [ "text-base leading-6 font-medium text-gray-900" ] ]
                            [ txt "Delete this dataset" ]
                        ; div
                            ~a:[ a_class [ "mt-2 max-w-xl text-sm leading-5 text-gray-500" ] ]
                            [ p [ txt "Once you delete a dataset, we will delete all of its data. Please be certain." ]
                            ]
                        ]
                    ; div
                        ~a:[ a_class [ "mt-5 sm:mt-0 sm:ml-6 sm:flex-shrink-0 sm:flex sm:items-center" ] ]
                        [ div
                            ~a:[ a_class [ "inline-flex rounded-md shadow-sm" ] ]
                            [ Delete_dataset_modal.make
                                ~dataset
                                [ button
                                    ~a:
                                      [ a_custom "@click" "open = true"
                                      ; a_button_type `Button
                                      ; a_class
                                          [ "inline-flex items-center py-2 px-4 border border-transparent rounded-md \
                                             shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 \
                                             focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                                          ]
                                      ]
                                    [ txt "Delete this dataset" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

let edit_sources ~user ~dataset ?alert:_ () =
  let open Tyxml.Html in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  Edit_layout.make
    ~title:"Edit dataset sources · Sapiens"
    ~dataset
    ~user
    ~active:Sources
    [ div
        ~a:[ a_class [ "w-full flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md" ] ]
        [ div
            ~a:[ a_class [ "text-center" ] ]
            [ svg
                ~a:
                  [ Tyxml.Svg.a_class [ "mx-auto h-12 w-12 text-gray-400" ]
                  ; Tyxml.Svg.a_stroke `CurrentColor
                  ; Tyxml.Svg.a_fill `None
                  ; Tyxml.Svg.a_viewBox (0., 0., 48., 48.)
                  ]
                [ Tyxml.Svg.path
                    ~a:
                      [ Tyxml.Svg.a_d
                          "M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 \
                           4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                      ; a_svg_custom "stroke-width" "2"
                      ; a_svg_custom "stroke-linecap" "round"
                      ; a_svg_custom "stroke-linejoin" "round"
                      ]
                    []
                ]
            ; p
                ~a:[ a_class [ "mt-1 text-sm text-gray-600" ] ]
                [ button
                    ~a:
                      [ a_button_type `Button
                      ; a_class
                          [ "font-medium text-indigo-600 hover:text-indigo-500 focus:outline-none focus:underline \
                             transition duration-150 ease-in-out"
                          ]
                      ]
                    [ txt "Upload a file" ]
                ; txt " or drag and drop"
                ]
            ; p ~a:[ a_class [ "mt-1 text-xs text-gray-500" ] ] [ txt "PNG, JPG, GIF up to 10MB" ]
            ]
        ]
    ]

let edit_collaborators ~user ~dataset ?alert () =
  let open Tyxml.Html in
  Edit_layout.make
    ~title:"Edit dataset collaborators · Sapiens"
    ~dataset
    ~user
    ~active:Collaborators
    [ (match alert with Some alert -> div ~a:[ a_class [ "mb-8" ] ] [ Alert.make alert ] | None -> div [])
    ; form
        ~a:[ a_action ("/datasets/" ^ string_of_int dataset.id ^ "/invite"); a_method `Post ]
        [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "PUT" ] ()
        ; div
            ~a:[ a_class [ "w-full max-w-xl" ] ]
            [ div
                [ label
                    ~a:[ a_label_for "email"; a_class [ "block text-sm font-medium leading-5 text-gray-700" ] ]
                    [ txt "Invite collaborator" ]
                ; div
                    ~a:[ a_class [ "mt-1 flex" ] ]
                    [ div
                        ~a:[ a_class [ "relative flex-grow focus-within:z-10 rounded-md shadow-sm" ] ]
                        [ div
                            ~a:[ a_class [ "absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none" ] ]
                            [ svg
                                ~a:
                                  [ Tyxml.Svg.a_class [ "h-5 w-5 text-gray-400" ]
                                  ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                                  ; Tyxml.Svg.a_fill `CurrentColor
                                  ]
                                [ Tyxml.Svg.path
                                    ~a:
                                      [ Tyxml.Svg.a_d
                                          "M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 \
                                           17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 \
                                           11a5 5 0 015 5v1H1v-1a5 5 0 015-5z"
                                      ]
                                    []
                                ]
                            ]
                        ; input
                            ~a:
                              [ a_id "email"
                              ; a_name "email"
                              ; a_input_type `Text
                              ; a_class
                                  [ "border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 w-full \
                                     sm:text-sm pl-10"
                                  ]
                              ; a_placeholder "user@email.com"
                              ]
                            ()
                        ]
                    ; span
                        ~a:[ a_class [ "ml-4 inline-flex rounded-md shadow-sm" ] ]
                        [ button
                            ~a:
                              [ a_button_type `Submit
                              ; a_class
                                  [ "inline-flex items-center py-2 px-4 border border-transparent rounded-md shadow-sm \
                                     text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 \
                                     focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                  ]
                              ]
                            [ txt "Send invite" ]
                        ]
                    ]
                ]
            ]
        ]
    ; (match dataset.collaborators with [] -> div [] | _ -> Collaborator_table.make ~dataset dataset.collaborators)
    ]
