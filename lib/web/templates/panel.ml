open Tyxml.Html

module Header = struct
  let createElement ~children () = div ~a:[ a_class [ "border-b border-gray-200 px-4 py-5 sm:px-6" ] ] children
end

let header children = Header.createElement ~children ()

module Body = struct
  let createElement ~children () = div ~a:[ a_class [ "px-4 py-5 sm:p-6" ] ] children
end

let body children = Body.createElement ~children ()

module Footer = struct
  let createElement ?(gray = false) ~children () =
    div
      ~a:
        [ a_class
            [ (if gray then
                 "bg-gray-50 px-4 py-4 sm:px-6"
              else
                "border-t border-gray-200 px-4 py-4 sm:px-6")
            ]
        ]
      children
end

let footer ?gray children = Footer.createElement ?gray ~children ()

let createElement ~children () = div ~a:[ a_class [ "bg-white overflow-hidden shadow rounded-lg" ] ] children

let make children = createElement ~children ()
