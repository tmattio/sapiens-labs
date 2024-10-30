open Opium
open Sapiens_backend
open Lwt.Syntax

let halt response : 'a = raise (Rock.Server_connection.Halt response)

let index req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* tasks = Annotation.list_user_annotation_tasks ~as_:user in
    let+ tasks_progress = Annotation.get_annotation_tasks_user_progress ~user in
    tasks, tasks_progress
  in
  match result with
  | Ok (tasks, progress) ->
    let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
    let alert = Flash.get_message req in
    Lwt.return
    @@ Response.of_html (Task_view.index ~user ~tasks ~progress ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error

let show req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let task_id = Opium.Router.param req "id" in
  let* result =
    let open Lwt_result.Syntax in
    let* task_id =
      try Lwt.return (Ok (int_of_string task_id)) with
      | Failure _ ->
        Lwt.return (Error `Not_found)
    in
    let* task = Annotation.get_annotation_task_by_id ~as_:user task_id in
    let+ annotations =
      Sapiens_backend.Annotation.get_annotation_task_user_annotations ~user task
    in
    ( task
    , Sapiens_common.Annotation.
        { name = Sapiens_backend.Annotation.Task.Name.to_string task.name
        ; guidelines = task.guidelines_url
        ; input_definitions = task.input_features
        ; output_definitions = task.output_features
        ; annotations
        } )
  in
  match result with
  | Ok (_, user_task) ->
    (match Request.header "Accept" req with
    | Some "application/json" ->
      user_task
      |> Sapiens_common.Annotation.user_annotation_task_to_yojson
      |> Response.of_json
      |> Lwt.return
    | _ ->
      Lwt.return @@ Response.of_html (Annotation_tool_view.make ()))
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let update req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let task_id = Opium.Router.param req "id" in
  let* result =
    let open Lwt_result.Syntax in
    let* task_id =
      try Lwt.return (Ok (int_of_string task_id)) with
      | Failure _ ->
        Lwt.return (Error `Not_found)
    in
    let* _task = Annotation.get_annotation_task_by_id ~as_:user task_id in
    let* json =
      Request.to_json req
      |> Lwt.map
           (Option.to_result ~none:(`Msg "Could not decode the annotation"))
    in
    let* { datapoint_id; annotations } =
      Sapiens_common.Annotation.user_annotation_of_yojson json
      |> Lwt_result.lift
      |> Lwt_result.map_err (fun err -> `Msg err)
    in
    Sapiens_backend.Annotation.annotate_datapoint
      ~user_id:user.id
      ~annotation_task_id:task_id
      ~datapoint_id
      annotations
  in
  match result with
  | Ok () ->
    Sapiens_common.Annotation.Ok
    |> Sapiens_common.Annotation.user_annotation_response_to_yojson
    |> Response.of_json
    |> Lwt.return
  | Error (`Msg err) ->
    Sapiens_common.Annotation.Error err
    |> Sapiens_common.Annotation.user_annotation_response_to_yojson
    |> Response.of_json ~status:`Bad_request
    |> halt
  | Error (`Internal_error _) ->
    Sapiens_common.Annotation.Error "An internal error occured"
    |> Sapiens_common.Annotation.user_annotation_response_to_yojson
    |> Response.of_json ~status:`Internal_server_error
    |> halt
  | Error `Not_found | Error `Permission_denied ->
    Sapiens_common.Annotation.Error "Not found"
    |> Sapiens_common.Annotation.user_annotation_response_to_yojson
    |> Response.of_json ~status:`Not_found
    |> halt
