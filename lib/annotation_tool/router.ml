type url =
  { path : string list
  ; hash : string
  ; search : string
  }
[@@deriving sexp, compare]

type location =
  { href : string
  ; host : string
  ; hostname : string
  ; protocol : string
  ; origin : string option
  ; port_ : string
  ; pathname : string
  ; search : string
  ; hash : string
  }

let path_of_location location_opt =
  match location_opt with
  | None ->
    []
  | Some location ->
    (match location.pathname with
    | "" | "/" ->
      []
    | raw ->
      let raw = StringLabels.sub raw ~pos:1 ~len:(String.length raw - 1) in
      let raw =
        match raw.[String.length raw - 1] with
        | '/' ->
          StringLabels.sub raw ~pos:0 ~len:(String.length raw - 1)
        | _ ->
          raw
      in
      String.split_on_char '/' raw)

let hash_of_location location_opt =
  match location_opt with
  | None ->
    ""
  | Some (location : location) ->
    (match location.hash with
    | "" | "#" ->
      ""
    | raw ->
      StringLabels.sub raw ~pos:1 ~len:(String.length raw - 1))

let search_of_location location_opt =
  match location_opt with
  | None ->
    ""
  | Some (location : location) ->
    (match location.search with
    | "" | "?" ->
      ""
    | raw ->
      StringLabels.sub raw ~pos:1 ~len:(String.length raw - 1))

let current_url () =
  let open Js_of_ocaml in
  let js_location_opt =
    Js.some Dom_html.window##.location |> Js.Opt.to_option
  in
  let location_opt =
    Option.map
      (fun js_location ->
        { href = js_location##.href |> Js.to_string
        ; host = js_location##.host |> Js.to_string
        ; hostname = js_location##.hostname |> Js.to_string
        ; protocol = js_location##.protocol |> Js.to_string
        ; origin =
            Js.Optdef.map js_location##.origin Js.to_string
            |> Js.Optdef.to_option
        ; port_ = js_location##.port |> Js.to_string
        ; pathname = js_location##.pathname |> Js.to_string
        ; search = js_location##.search |> Js.to_string
        ; hash = js_location##.hash |> Js.to_string
        })
      js_location_opt
  in
  let path = path_of_location location_opt in
  let hash = hash_of_location location_opt in
  let search = search_of_location location_opt in
  { path; hash; search }

(** Listen for the Dom hash change event. This binds to the event for the
    lifecycle of the application. *)
let on_url_change ~f =
  let open Js_of_ocaml in
  Js.some
    (Dom.addEventListener
       Dom_html.window
       Dom_html.Event.popstate
       (Dom_html.handler (fun (_ev : #Dom_html.event Js.t) ->
            f (current_url ());
            Js._true))
       Js._false)
