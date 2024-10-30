open Opium
open Sapiens_backend
open Lwt.Syntax

let index req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* models = Model.list_user_models user in
  match models with
  | Ok models ->
    let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
    let alert = Flash.get_message req in
    Lwt.return @@ Response.of_html (Model_view.index ~user ~models ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error

let new_ req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (Model_view.new_ ~user ?alert ())

let create req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* name =
      Common.Request.decode_param ~decoder:Model.Model.Name.of_string "name" req
    in
    let* description =
      Common.Request.decode_param_opt
        ~decoder:Model.Model.Description.of_string
        "description"
        req
    in
    Model.create_model ~name ?description ~user ()
  in
  match result with
  | Ok model ->
    Lwt.return
    @@ Response.redirect_to ~status:`Found ("/models/" ^ string_of_int model.id)
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "You already created a model with the same name."
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    Lwt.return
    @@ Response.of_html (Model_view.new_ ~user ~alert:(`error message) ())

let show req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let model_id = Opium.Router.param req "id" in
  let* model =
    try Model.get_model_by_id (int_of_string model_id) with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match model with
  | Ok model ->
    Lwt.return @@ Response.of_html (Model_view.show ~model ~user ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found ->
    Lwt.return Common.Response.not_found

let edit req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let model_id = Opium.Router.param req "id" in
  let* model =
    try Model.get_model_by_id (int_of_string model_id) with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match model with
  | Ok model ->
    Lwt.return @@ Response.of_html (Model_view.edit ~model ~user ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found ->
    Lwt.return Common.Response.not_found

let update _req = Lwt.return @@ Response.of_plain_text "" ~status:`OK

let delete _req = Lwt.return @@ Response.of_plain_text "" ~status:`OK
