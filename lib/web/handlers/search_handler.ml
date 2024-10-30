open Opium
open Sapiens_backend
open Lwt.Syntax

let search req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let param = Uri.get_query_param (Uri.of_string req.Request.target) "q" in
  match param with
  | Some query ->
    let query = Dataset.Dataset.Query.of_string query in
    let* datasets = Dataset.search_datasets ~as_:user query in
    (match datasets with
    | Ok datasets ->
      let user =
        Context.find_exn User_auth_middleware.Env.key req.Request.env
      in
      let alert = Flash.get_message req in
      Lwt.return
      @@ Response.of_html (Search_view.search ~user ~datasets ?alert ())
    | Error (`Internal_error _) ->
      Lwt.return Common.Response.internal_error)
  | None ->
    Lwt.return @@ Response.make ~status:`Bad_request ()
