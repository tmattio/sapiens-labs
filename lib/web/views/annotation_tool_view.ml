let make () =
  let open Tyxml.Html in
  html
    ~a:[ a_lang "en" ]
    (head
       (title (txt "Annotation · Sapiens"))
       [ meta ~a:[ a_charset "utf-8" ] ()
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
       ; script ~a:[ a_src "/annotation-tool.js"; a_defer () ] (txt "")
       ])
    (body
       ~a:[ a_class [ "antialiased" ] ]
       [ noscript [ txt "You need to enable JavaScript to run this app." ]; div ~a:[ a_id "root" ] [] ])
