let index ~tasks ~user ~progress:progress_ ?alert () =
  let open Tyxml.Html in
  Layout.make
    ~title:"Sapiens"
    [ Layout.navbar ~user ~active:Annotation_tasks ()
    ; (match alert with Some alert -> div ~a:[ a_class [ "my-4" ] ] [ Alert.make alert ] | None -> div [])
    ; header
        ~a:[ a_class [ "pt-10 pb-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ] ]
        [ div
            ~a:[ a_class [ "md:flex md:items-center md:justify-between" ] ]
            [ div
                ~a:[ a_class [ "flex-1 min-w-0" ] ]
                [ h1
                    ~a:[ a_class [ "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate" ] ]
                    [ txt "Your annotation tasks" ]
                ]
            ]
        ]
    ; Layout.content
        [ (match tasks with
          | [] ->
            div
              ~a:[ a_class [ "mx-auto max-w-xl" ] ]
              [ div
                  [ div
                      ~a:[ a_class [ "mx-auto flex items-center justify-center" ] ]
                      [ img ~src:"/undraw_empty_street_sfxm.svg" ~alt:"No tasks" () ]
                  ; div
                      ~a:[ a_class [ "mt-3 text-center sm:mt-5" ] ]
                      [ h3
                          ~a:[ a_class [ "text-2xl leading-6 font-medium text-gray-900" ]; a_id "modal-headline" ]
                          [ txt "No task" ]
                      ; div
                          ~a:[ a_class [ "mt-2" ] ]
                          [ p
                              ~a:[ a_class [ "text-sm leading-5 text-gray-500" ] ]
                              [ txt
                                  "You don't have any task. Once you are assigned to an annotation task in a dataset, \
                                   it will be listed here."
                              ]
                          ]
                      ]
                  ]
              ]
          | _ ->
            User_task_table.make ~progress:progress_ tasks)
        ]
    ]
