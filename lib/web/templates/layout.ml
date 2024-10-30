let notification_icon =
  let open Tyxml.Html in
  svg
    ~a:
      [ Tyxml.Svg.a_class [ "h-6 w-6" ]
      ; Tyxml.Svg.a_stroke `CurrentColor
      ; Tyxml.Svg.a_fill `None
      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
      ]
    [ Tyxml.Svg.path
        ~a:
          [ Xml.string_attrib "stroke-linecap" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-linejoin" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-width" "2" |> Tyxml.Svg.to_attrib
          ; Tyxml.Svg.a_d
              "M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 \
               6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
          ]
        []
    ]

let menu_icon =
  let open Tyxml.Html in
  svg
    ~a:
      [ Tyxml.Svg.a_class [ "h-6 w-6" ]
      ; Tyxml.Svg.a_stroke `CurrentColor
      ; Tyxml.Svg.a_fill `None
      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
      ]
    [ Tyxml.Svg.path
        ~a:
          [ Xml.string_attrib "stroke-linecap" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-linejoin" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-width" "2" |> Tyxml.Svg.to_attrib
          ; Tyxml.Svg.a_d "M4 6h16M4 12h16M4 18h16"
          ]
        []
    ]

let close_menu_icon =
  let open Tyxml.Html in
  svg
    ~a:
      [ Tyxml.Svg.a_class [ "h-6 w-6" ]
      ; Tyxml.Svg.a_stroke `CurrentColor
      ; Tyxml.Svg.a_fill `None
      ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
      ]
    [ Tyxml.Svg.path
        ~a:
          [ Xml.string_attrib "stroke-linecap" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-linejoin" "round" |> Tyxml.Svg.to_attrib
          ; Xml.string_attrib "stroke-width" "2" |> Tyxml.Svg.to_attrib
          ; Tyxml.Svg.a_d "M6 18L18 6M6 6l12 12"
          ]
        []
    ]

let dots_icon =
  let open Tyxml.Html in
  svg
    ~a:[ Tyxml.Svg.a_class [ "h-5 w-5" ]; Tyxml.Svg.a_fill `CurrentColor; Tyxml.Svg.a_viewBox (0., 0., 20., 20.) ]
    [ Tyxml.Svg.path
        ~a:
          [ Tyxml.Svg.a_d "M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z"
          ]
        []
    ]

type navbar_item =
  | Datasets
  | Models
  | Annotation_tasks

let navbar ~user ?active () =
  let open Tyxml.Html in
  let a_custom x y = Xml.string_attrib x y |> to_attrib in
  let a_svg_custom x y = Tyxml.Xml.string_attrib x y |> Tyxml.Svg.to_attrib in
  nav
    ~a:
      [ a_custom "x-data" "{ open: false }"
      ; a_custom "@keydown.window.escape" "open = false"
      ; a_class [ "bg-gray-800" ]
      ]
    [ div
        ~a:[ a_class [ "max-w-7xl mx-auto px-2 sm:px-4 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "relative flex items-center justify-between h-16" ] ]
            [ div
                ~a:[ a_class [ "flex items-center px-2 lg:px-0" ] ]
                [ div
                    ~a:[ a_class [ "flex-shrink-0" ] ]
                    [ img
                        ~src:"https://tailwindui.com/img/logos/v1/workflow-mark-on-dark.svg"
                        ~alt:"Sapiens logo"
                        ~a:[ a_class [ "block lg:hidden h-8 w-auto" ] ]
                        ()
                    ; img
                        ~src:"https://tailwindui.com/img/logos/v1/workflow-logo-on-dark.svg"
                        ~alt:"Sapiens logo"
                        ~a:[ a_class [ "hidden lg:block h-8 w-auto" ] ]
                        ()
                    ]
                ; div
                    ~a:[ a_class [ "hidden lg:block lg:ml-6" ] ]
                    [ div
                        ~a:[ a_class [ "flex" ] ]
                        [ a
                            ~a:
                              [ a_href "/"
                              ; a_class
                                  [ ("px-3 py-2 rounded-md text-sm font-medium text-white focus:outline-none \
                                      focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                                    ^
                                    if Some Datasets = active then
                                      " bg-gray-900"
                                    else
                                      "")
                                  ]
                              ]
                            [ txt "Datasets" ]
                        ; a
                            ~a:
                              [ a_href "/models"
                              ; a_class
                                  [ ("ml-4 px-3 py-2 rounded-md text-sm font-medium text-white focus:outline-none \
                                      focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                                    ^
                                    if Some Models = active then
                                      " bg-gray-900"
                                    else
                                      "")
                                  ]
                              ]
                            [ txt "Models" ]
                        ; a
                            ~a:
                              [ a_href "/tasks"
                              ; a_class
                                  [ ("ml-4 px-3 py-2 rounded-md text-sm font-medium text-white focus:outline-none \
                                      focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                                    ^
                                    if Some Annotation_tasks = active then
                                      " bg-gray-900"
                                    else
                                      "")
                                  ]
                              ]
                            [ txt "Annotation Tasks" ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "flex-1 flex justify-center px-2 lg:ml-6 lg:justify-end" ] ]
                [ div
                    ~a:[ a_class [ "max-w-lg w-full lg:max-w-xs" ] ]
                    [ form
                        ~a:[ a_action "/search"; a_method `Get ]
                        [ label ~a:[ a_label_for "search"; a_class [ "sr-only" ] ] [ txt "Search" ]
                        ; div
                            ~a:[ a_class [ "relative" ] ]
                            [ div
                                ~a:
                                  [ a_class [ "absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none" ] ]
                                [ svg
                                    ~a:
                                      [ Tyxml.Svg.a_class [ "h-5 w-5 text-gray-400" ]
                                      ; Tyxml.Svg.a_fill `CurrentColor
                                      ; Tyxml.Svg.a_viewBox (0., 0., 20., 20.)
                                      ]
                                    [ Tyxml.Svg.path
                                        ~a:
                                          [ a_svg_custom "fill-rule" "evenodd"
                                          ; Tyxml.Svg.a_d
                                              "M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 \
                                               01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
                                          ; a_svg_custom "clip-rule" "evenodd"
                                          ]
                                        []
                                    ]
                                ]
                            ; input
                                ~a:
                                  [ a_id "search"
                                  ; a_name "q"
                                  ; a_class
                                      [ "block w-full pl-10 pr-3 py-2 border border-transparent rounded-md bg-gray-700 \
                                         text-gray-300 placeholder-gray-400 focus:outline-none focus:bg-white \
                                         focus:text-gray-900 sm:text-sm transition duration-150 ease-in-out"
                                      ]
                                  ; a_placeholder "Search"
                                  ; a_input_type `Search
                                  ]
                                ()
                            ]
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "flex lg:hidden" ] ]
                [ button
                    ~a:
                      [ a_custom "@click" "open = !open"
                      ; a_class
                          [ "inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white \
                             hover:bg-gray-700 focus:outline-none focus:bg-gray-700 focus:text-white transition \
                             duration-150 ease-in-out"
                          ]
                      ; a_aria "label" [ "open ? 'Close main menu' : 'Main menu'" ]
                      ; a_aria "label" [ "Main menu" ]
                      ; a_aria "expanded" [ "open" ]
                      ]
                    [ svg
                        ~a:
                          [ a_svg_custom "x-state:on" "Menu open"
                          ; a_svg_custom "x-state:off" "Menu closed"
                          ; Tyxml.Svg.a_class [ "block h-6 w-6" ]
                          ; Tyxml.Svg.a_fill `None
                          ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                          ; Tyxml.Svg.a_stroke `CurrentColor
                          ]
                        [ Tyxml.Svg.path
                            ~a:
                              [ a_svg_custom "stroke-linecap" "round"
                              ; a_svg_custom "stroke-linejoin" "round"
                              ; a_svg_custom "stroke-width" "2"
                              ; Tyxml.Svg.a_d "M4 6h16M4 12h16M4 18h16"
                              ]
                            []
                        ]
                    ; svg
                        ~a:
                          [ a_svg_custom "x-state:on" "Menu open"
                          ; a_svg_custom "x-state:off" "Menu closed"
                          ; Tyxml.Svg.a_class [ "hidden h-6 w-6" ]
                          ; Tyxml.Svg.a_fill `None
                          ; Tyxml.Svg.a_viewBox (0., 0., 24., 24.)
                          ; Tyxml.Svg.a_stroke `CurrentColor
                          ]
                        [ Tyxml.Svg.path
                            ~a:
                              [ a_svg_custom "stroke-linecap" "round"
                              ; a_svg_custom "stroke-linejoin" "round"
                              ; a_svg_custom "stroke-width" "2"
                              ; Tyxml.Svg.a_d "M6 18L18 6M6 6l12 12"
                              ]
                            []
                        ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "hidden lg:block lg:ml-4" ] ]
                [ div
                    ~a:[ a_class [ "flex items-center" ] ]
                    [ button
                        ~a:
                          [ a_class
                              [ "flex-shrink-0 p-1 border-2 border-transparent text-gray-400 rounded-full \
                                 hover:text-white focus:outline-none focus:text-white focus:bg-gray-700 transition \
                                 duration-150 ease-in-out"
                              ]
                          ; a_aria "label" [ "Notifications" ]
                          ]
                        [ notification_icon ]
                    ; div
                        ~a:
                          [ a_custom "@click.away" "open = false"
                          ; a_custom "@keydown.escape" "open = false"
                          ; a_class [ "ml-4 relative flex-shrink-0" ]
                          ; a_custom "x-data" "{ open: false }"
                          ]
                        [ div
                            [ button
                                ~a:
                                  [ a_custom "@click" "open = !open"
                                  ; a_custom "x-bind:aria-expanded" "open"
                                  ; a_class [ "flex items-center text-gray-400 hover:text-white" ]
                                  ; a_id "user-menu"
                                  ; a_aria "label" [ "User menu" ]
                                  ; a_aria "haspopup" [ "true" ]
                                  ]
                                [ dots_icon ]
                            ]
                        ; div
                            ~a:
                              [ a_custom "x-show" "open"
                              ; a_custom "x-description" "Profile dropdown panel, show/hide based on dropdown state."
                              ; a_custom "x-transition:enter" "transition ease-out duration-100"
                              ; a_custom "x-transition:enter-start" "transform opacity-0 scale-95"
                              ; a_custom "x-transition:enter-end" "transform opacity-100 scale-100"
                              ; a_custom "x-transition:leave" "transition ease-in duration-75"
                              ; a_custom "x-transition:leave-start" "transform opacity-100 scale-100"
                              ; a_custom "x-transition:leave-end" "transform opacity-0 scale-95"
                              ; a_class
                                  [ "z-10 origin-top-right absolute right-0 mt-2 w-56 min-w-max-content rounded-md \
                                     shadow-lg"
                                  ]
                              ; a_style "display: none;"
                              ]
                            [ div
                                ~a:
                                  [ a_class [ "rounded-md bg-white ring-1 ring-black ring-opacity-5" ]
                                  ; a_role [ "menu" ]
                                  ; a_aria "orientation" [ "vertical" ]
                                  ; a_aria "labelledby" [ "user-menu" ]
                                  ]
                                [ div
                                    ~a:[ a_class [ "px-4 py-3" ] ]
                                    [ p ~a:[ a_class [ "text-sm" ] ] [ txt "Signed in as" ]
                                    ; p
                                        ~a:[ a_class [ "text-sm font-medium text-gray-900 truncate" ] ]
                                        [ txt Sapiens_backend.Account.User.(Email.to_string user.email) ]
                                    ]
                                ; div ~a:[ a_class [ "border-t border-gray-100" ] ] []
                                ; div
                                    ~a:[ a_class [ "py-1" ] ]
                                    [ a
                                        ~a:
                                          [ a_href "/users/settings"
                                          ; a_class
                                              [ "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 \
                                                 focus:outline-none focus:bg-gray-100 transition duration-150 \
                                                 ease-in-out"
                                              ]
                                          ; a_role [ "menuitem" ]
                                          ]
                                        [ txt "Settings" ]
                                    ; form
                                        ~a:[ a_action "/users/logout"; a_method `Post ]
                                        [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "DELETE" ] ()
                                        ; button
                                            ~a:
                                              [ a_button_type `Submit
                                              ; a_class
                                                  [ "block w-full text-left px-4 py-2 text-sm text-gray-700 \
                                                     hover:bg-gray-100 focus:outline-none focus:bg-gray-100 transition \
                                                     duration-150 ease-in-out"
                                                  ]
                                              ; a_role [ "menuitem" ]
                                              ]
                                            [ txt "Sign out" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ; div
        ~a:
          [ a_custom "x-description" "Mobile menu, toggle classes based on menu state."
          ; a_custom "x-state:on" "Menu open"
          ; a_custom "x-state:off" "Menu closed"
          ; a_custom ":class" "{ 'block': open, 'hidden': !open }"
          ; a_class [ "hidden lg:hidden" ]
          ]
        [ div
            ~a:[ a_class [ "px-2 pt-2 pb-3" ] ]
            [ a
                ~a:
                  [ a_href "/"
                  ; a_class
                      [ ("block px-3 py-2 rounded-md text-base font-medium text-white focus:outline-none \
                          focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                        ^
                        if Some Datasets = active then
                          " bg-gray-900"
                        else
                          "")
                      ]
                  ]
                [ txt "Datasets" ]
            ; a
                ~a:
                  [ a_href "/models"
                  ; a_class
                      [ ("mt-1 block px-3 py-2 rounded-md text-base font-medium text-white focus:outline-none \
                          focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                        ^
                        if Some Models = active then
                          " bg-gray-900"
                        else
                          "")
                      ]
                  ]
                [ txt "Models" ]
            ; a
                ~a:
                  [ a_href "/tasks"
                  ; a_class
                      [ ("mt-1 block px-3 py-2 rounded-md text-base font-medium text-white focus:outline-none \
                          focus:text-white focus:bg-gray-700 transition duration-150 ease-in-out"
                        ^
                        if Some Annotation_tasks = active then
                          " bg-gray-900"
                        else
                          "")
                      ]
                  ]
                [ txt "Annotation Tasks" ]
            ]
        ; div
            ~a:[ a_class [ "pt-4 pb-3 border-t border-gray-700" ] ]
            [ div
                ~a:[ a_class [ "flex items-center px-5" ] ]
                [ div
                    [ div
                        ~a:[ a_class [ "text-base font-medium leading-6 text-white" ] ]
                        [ txt Sapiens_backend.Account.User.(Username.to_string user.username) ]
                    ; div
                        ~a:[ a_class [ "text-sm font-medium text-gray-400" ] ]
                        [ txt Sapiens_backend.Account.User.(Email.to_string user.email) ]
                    ]
                ]
            ; div
                ~a:[ a_class [ "mt-3 px-2" ] ]
                [ a
                    ~a:
                      [ a_href "/users/settings"
                      ; a_class
                          [ "mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white \
                             hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700 transition \
                             duration-150 ease-in-out"
                          ]
                      ; a_role [ "menuitem" ]
                      ]
                    [ txt "Settings" ]
                ; form
                    ~a:[ a_action "/users/logout"; a_method `Post ]
                    [ input ~a:[ a_input_type `Hidden; a_name "_method"; a_value "DELETE" ] ()
                    ; button
                        ~a:
                          [ a_button_type `Submit
                          ; a_class
                              [ "mt-1 block w-full text-left px-3 py-2 rounded-md text-base font-medium text-gray-400 \
                                 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white \
                                 focus:bg-gray-700"
                              ]
                          ; a_role [ "menuitem" ]
                          ]
                        [ txt "Sign out" ]
                    ]
                ]
            ]
        ]
    ]

let page_header ~title:title_ ?subtitle () =
  let open Tyxml.Html in
  header
    ~a:[ a_class [ "bg-white shadow-sm" ] ]
    [ div
        ~a:[ a_class [ "max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8" ] ]
        ([ h1 ~a:[ a_class [ "text-lg leading-6 font-semibold text-gray-900" ] ] [ txt title_ ] ]
        @
        match subtitle with
        | Some subtitle ->
          [ p ~a:[ a_class [ "mt-1 max-w-2xl text-sm text-gray-500" ] ] [ txt subtitle ] ]
        | None ->
          [])
    ]

let page_title ~title:title_ ?subtitle () =
  let open Tyxml.Html in
  header
    ~a:[ a_class [ "pt-10 pb-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
    ([ h1 ~a:[ a_class [ "text-3xl font-bold leading-tight text-gray-900" ] ] [ txt title_ ] ]
    @
    match subtitle with
    | Some subtitle ->
      [ p ~a:[ a_class [ "mt-1 max-w-2xl text-sm text-gray-500" ] ] [ txt subtitle ] ]
    | None ->
      [])

let content children =
  let open Tyxml.Html in
  main
    [ div
        ~a:[ a_class [ "max-w-7xl mx-auto py-6 sm:px-6 lg:px-8" ] ]
        [ div ~a:[ a_class [ "px-4 py-4 sm:px-0" ] ] children ]
    ]

let turbolinks_scripts =
  let open Tyxml.Html in
  if Sapiens_backend.Config.is_prod then
    [ script ~a:[ a_src "/helpers.js" ] (txt "")
    ; script ~a:[ a_src "/vendor/turbolinks.js" ] (txt "")
    ; script ~a:[ a_src "/vendor/morphdom-umd.min.js" ] (txt "")
    ; script ~a:[ a_src "/vendor/turbolinksMorphdom.js" ] (txt "")
    ; script ~a:[ a_src "/vendor/turbolinksInstantClick.js" ] (txt "")
    ]
  else
    []

let make ~title:title_ children =
  let open Tyxml.Html in
  html
    ~a:[ a_lang "en" ]
    (head
       (title (txt title_))
       ([ meta ~a:[ a_charset "utf-8" ] ()
        ; meta ~a:[ a_name "viewport"; a_content "width=device-width, initial-scale=1" ] ()
        ; meta ~a:[ a_name "theme-color"; a_content "#000000" ] ()
        ; meta
            ~a:
              [ a_name "description"
              ; a_content "Sapiens is a platform to create, share and discover machine learning models and datasets."
              ]
            ()
        ; link ~rel:[ `Icon ] ~href:"/favicon.ico" ()
        ; link ~rel:[ `Stylesheet ] ~href:"https://rsms.me/inter/inter.css" ()
        ; link ~rel:[ `Stylesheet ] ~href:"/main.css" ()
        ; script
            ~a:[ a_src "https://cdn.jsdelivr.net/gh/alpinejs/alpine@v2.7.0/dist/alpine.min.js"; a_defer () ]
            (txt "")
        ]
       @ turbolinks_scripts))
    (body ~a:[ a_class [ "antialiased" ] ] children)
