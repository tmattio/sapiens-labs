let make url =
  let open Tyxml.Html in
  a
    ~a:[ a_href url; a_target "_blank" ]
    [ img
        ~a:[ class_ "flex-shrink-0 mx-auto bg-black rounded-md max-h-96" ]
        ~src:url
        ~alt:""
        ()
    ]
