open Js_of_ocaml

module Loader = struct
  let make =
    let open Tyxml.Html in
    div [ txt "Loading..." ]
end

let doc =
  match (Router.current_url ()).path with
  | [ "tasks"; task_id ] ->
    (match int_of_string_opt task_id with
    | Some task_id ->
      let open Lwd_syntax in
      let annotations = Use.fetch_task task_id in
      let* annotations = Lwd.get annotations in
      (match annotations with
      | Not_asked ->
        Tyxml.Html.div
          [ Tyxml.Html.txt
              "The annotation tool did not asked for the annotation. This is \
               most likely a bug, please report it."
          ]
      | Loading ->
        Loader.make
      | Error _ ->
        Error.make
      | Loaded t ->
        (match Sapiens_common.Annotation.user_annotation_task_of_yojson t with
        | Ok t ->
          App.make ~task_id t
        | Error _ ->
          Error.make))
    | None ->
      Error.make)
  | _ ->
    Error.make

let onload _ =
  let main =
    Js.Opt.get
      (Dom_html.window##.document##getElementById (Js.string "root"))
      (fun () -> assert false)
  in
  let (_ : Tyxml_lwd.Lwdom.Scheduler.job) =
    Tyxml_lwd.Lwdom.Scheduler.append_to_dom doc main
  in
  Js._false

let start () = Dom_html.window##.onload := Dom_html.handler onload
