open Opium
open Lwt.Syntax

let halt response : 'a = raise (Rock.Server_connection.Halt response)

let get_dataset_or_halt req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let dataset_id = Opium.Router.param req "id" in
  let* dataset =
    try
      Sapiens_backend.Dataset.get_dataset_by_id
        ~as_:user
        (int_of_string dataset_id)
    with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match dataset with
  | Ok dataset ->
    Lwt.return dataset
  | Error (`Internal_error _) ->
    halt Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    halt Common.Response.not_found

let index req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* datasets =
    Sapiens_backend.Dataset.list_user_shared_datasets ~as_:user user
  in
  match datasets with
  | Ok datasets ->
    let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
    let alert = Flash.get_message req in
    Lwt.return
    @@ Response.of_html (Dataset_view.index ~user ~datasets ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error

let new_ req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  Lwt.return @@ Response.of_html (Dataset_view.new_ ~user ?alert ())

let create req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* name =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Dataset.Dataset.Name.of_string
        "name"
        req
    in
    let* description =
      Common.Request.decode_param_opt
        ~decoder:Sapiens_backend.Dataset.Dataset.Description.of_string
        "description"
        req
    in
    Sapiens_backend.Dataset.create_dataset ~as_:user ~name ?description ()
  in
  match result with
  | Ok dataset ->
    Lwt.return
    @@ Response.redirect_to
         ~status:`Found
         ("/datasets/" ^ string_of_int dataset.id)
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "You already created a dataset with the same name."
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    Lwt.return
    @@ Response.of_html (Dataset_view.new_ ~user ~alert:(`error message) ())

let show req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let* result =
    let open Lwt_result.Syntax in
    let* feature_definitions =
      Sapiens_backend.Dataset.get_dataset_feature_definitions ~as_:user dataset
    in
    let* datapoint_count =
      Sapiens_backend.Dataset.get_dataset_datapoint_count ~as_:user dataset
    in
    let+ datapoints =
      Sapiens_backend.Dataset.get_dataset_datapoints ~as_:user ~limit:10 dataset
    in
    datapoints, datapoint_count, feature_definitions
  in
  match result with
  | Ok (datapoints, datapoint_count, definitions) ->
    Lwt.return
    @@ Response.of_html
         (Dataset_show_view.make
            ~dataset
            ~datapoints
            ~datapoint_count
            ~definitions
            ~user
            ?alert
            ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let show_tasks req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let* result =
    let open Lwt_result.Syntax in
    let* tasks =
      Sapiens_backend.Annotation.list_dataset_annotation_tasks
        ~as_:user
        ~dataset
    in
    let+ tasks_progress =
      Sapiens_backend.Annotation.get_annotation_tasks_progress
        ~as_:user
        ~dataset
    in
    tasks, tasks_progress
  in
  match result with
  | Ok (tasks, progress) ->
    Lwt.return
    @@ Response.of_html
         (Dataset_task_view.index ~dataset ~user ~tasks ~progress ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let show_insights req =
  let* dataset = get_dataset_or_halt req in
  let alert = Flash.get_message req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  Response.of_html (Dataset_view.show_insights ~dataset ~user ?alert ())
  |> Lwt.return

let edit req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let dataset_id = Opium.Router.param req "id" in
  let* dataset =
    try
      Sapiens_backend.Dataset.get_dataset_by_id
        ~as_:user
        (int_of_string dataset_id)
    with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match dataset with
  | Ok dataset ->
    Lwt.return
    @@ Response.of_html (Dataset_settings_view.edit ~dataset ~user ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let edit_sources req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let dataset_id = Opium.Router.param req "id" in
  let* dataset =
    try
      Sapiens_backend.Dataset.get_dataset_by_id
        ~as_:user
        (int_of_string dataset_id)
    with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match dataset with
  | Ok dataset ->
    Lwt.return
    @@ Response.of_html
         (Dataset_settings_view.edit_sources ~dataset ~user ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let edit_collaborators req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  Lwt.return
  @@ Response.of_html
       (Dataset_settings_view.edit_collaborators ~dataset ~user ?alert ())

let update _req =
  (* TODO: Implement this *)
  Lwt.return @@ Response.of_plain_text "" ~status:`OK

let invite req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* email =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Email.of_string
        "email"
        req
    in
    let* invitee = Sapiens_backend.Account.User.get_by_email email in
    let* _ =
      Sapiens_backend.Dataset.deliver_collaboration_instructions
        ~as_:user
        ~url_fn:(fun token -> Config.base_url ^ "/datasets/invite/" ^ token)
        invitee
        dataset
    in
    Lwt.return (Ok email)
  in
  match result with
  | Ok _ ->
    Lwt.return
    @@ Response.of_html
         (Dataset_settings_view.edit_collaborators
            ~dataset
            ~user
            ~alert:(`success "An invitation has been sent to the user.")
            ())
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "This user is already a collaborator of the dataset."
      | `Validation_error err ->
        err
      | `Not_found ->
        "The user with this email could not be found."
      | `Permission_denied ->
        "You don't have the permission to invite a user."
      | `Internal_error _ ->
        "An internal error occured."
    in
    Lwt.return
    @@ Response.of_html
         (Dataset_settings_view.edit_collaborators
            ~dataset
            ~user
            ~alert:(`error message)
            ())

let accept_invite req =
  let token =
    Opium.Router.param req "token" |> Sapiens_backend.Token.of_string
  in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    Sapiens_backend.Dataset.accept_collaboration_invitation ~as_:user token
  in
  match result with
  | Ok dataset ->
    Response.redirect_to ("/datasets/" ^ string_of_int dataset.id)
    |> Flash.set_success
         "The collaboration invitation has been accepted succesfully."
    |> Lwt.return
  | Error `Not_found | Error `Invalid_token ->
    Response.redirect_to "/"
    |> Flash.set_error "Invitation link is invalid or it has expired."
    |> Lwt.return
  | Error (`Internal_error _) ->
    Response.redirect_to "/"
    |> Flash.set_error "An internal error occured."
    |> Lwt.return

let remove_collaborator req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* email =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Account.User.Email.of_string
        "email"
        req
    in
    let* collaborator = Sapiens_backend.Account.User.get_by_email email in
    let* _ =
      Sapiens_backend.Dataset.remove_collaborator ~as_:user collaborator dataset
    in
    Lwt.return (Ok email)
  in
  let* dataset = get_dataset_or_halt req in
  match result with
  | Ok _ ->
    Lwt.return
    @@ Response.of_html
         (Dataset_settings_view.edit_collaborators
            ~dataset
            ~user
            ~alert:(`success "The user no longer has access to the dataset.")
            ())
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "This user is already a collaborator of the dataset."
      | `Validation_error err ->
        err
      | `Not_found ->
        "The user with this email could not be found."
      | `Permission_denied ->
        "You don't have the permission to invite a user."
      | `Internal_error _ ->
        "An internal error occured."
    in
    Lwt.return
    @@ Response.of_html
         (Dataset_settings_view.edit_collaborators
            ~dataset
            ~user
            ~alert:(`error message)
            ())

let delete req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let dataset_id = Opium.Router.param req "id" in
  let* result =
    let open Lwt_result.Syntax in
    let* dataset =
      Sapiens_backend.Dataset.get_dataset_by_id
        ~as_:user
        (int_of_string dataset_id)
    in
    Sapiens_backend.Dataset.delete_dataset ~as_:user dataset
  in
  match result with
  | Ok () ->
    Response.redirect_to "/"
    |> Flash.set_success "The dataset has been deleted successfully."
    |> Lwt.return
  | Error `Not_found ->
    Lwt.return Common.Response.not_found
  | Error (`Internal_error _) ->
    Response.redirect_to ("/datasets/" ^ dataset_id ^ "/settings")
    |> Flash.set_error "An internal error occured."
    |> Lwt.return
  | Error `Permission_denied ->
    Response.redirect_to ("/datasets/" ^ dataset_id ^ "/settings")
    |> Flash.set_error "You do not have the permission to delete this dataset."
    |> Lwt.return

let upload _req =
  (* TODO: Implement this *)
  Lwt.return @@ Response.of_plain_text "" ~status:`OK

let show_upload req =
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let alert = Flash.get_message req in
  let dataset_id = Opium.Router.param req "id" in
  let* dataset =
    try
      Sapiens_backend.Dataset.get_dataset_by_id
        ~as_:user
        (int_of_string dataset_id)
    with
    | Failure _ ->
      Lwt.return (Error `Not_found)
  in
  match dataset with
  | Ok dataset ->
    Lwt.return
    @@ Response.of_html (Dataset_view.upload ~dataset ~user ?alert ())
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Not_found | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

(* Just defining the type to get the encoders for free *)
type datapoints = Sapiens_backend.Dataset.Datapoint.t list
[@@deriving to_yojson]

let export req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* datapoints =
    Sapiens_backend.Dataset.get_dataset_datapoints ~as_:user dataset
  in
  match datapoints with
  | Ok datapoints ->
    let json = datapoints_to_yojson datapoints in
    Response.of_json json
    |> Response.add_header
         ( "Content-Disposition"
         , "attachment; filename=\""
           ^ Sapiens_backend.Dataset.Dataset.Name.to_string dataset.name
           ^ ".json\"" )
    |> Lwt.return
  | Error (`Internal_error _) ->
    Lwt.return Common.Response.internal_error
  | Error `Permission_denied ->
    Lwt.return Common.Response.not_found

let new_task req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* definitions =
    Sapiens_backend.Dataset.get_dataset_feature_definitions ~as_:user dataset
  in
  let alert = Flash.get_message req in
  match definitions with
  | Ok definitions ->
    Lwt.return
    @@ Response.of_html
         (Dataset_task_view.new_ ~dataset ~user ~definitions ?alert ())
  | Error _ ->
    (* This should never happen: if the user can index the dataset, it should be
       able to index its feature definitions. *)
    halt Common.Response.internal_error

let create_task req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* name =
      Common.Request.decode_param
        ~decoder:Sapiens_backend.Annotation.Task.Name.of_string
        "name"
        req
    in
    let* assignee_id =
      Common.Request.decode_param
        ~decoder:(fun x ->
          int_of_string_opt x
          |> Option.to_result ~none:(`Msg "could not decode assignee ID"))
        "assignee"
        req
    in
    let* assignee = Sapiens_backend.Account.get_user_by_id assignee_id in
    let* guidelines_url =
      Request.urlencoded "guidelines_url" req |> Lwt_result.ok
    in
    let* input_feature_ids =
      Request.urlencoded_list "input_features" req |> Lwt_result.ok
    in
    let* () =
      match input_feature_ids with
      | [] ->
        Lwt.return_error (`Msg "Please select input features")
      | _ ->
        Lwt.return_ok ()
    in
    let* output_feature_ids =
      Request.urlencoded_list "output_features" req |> Lwt_result.ok
    in
    let* () =
      match output_feature_ids with
      | [] ->
        Lwt.return_error (`Msg "Please select output features")
      | _ ->
        Lwt.return_ok ()
    in
    let input_feature_ids = List.map int_of_string input_feature_ids in
    let output_feature_ids = List.map int_of_string output_feature_ids in
    Sapiens_backend.Annotation.create_annotation_task
      ~as_:user
      ~name
      ~assignee
      ?guidelines_url
      ~datapoint_count:0
      ~input_feature_ids
      ~output_feature_ids
      dataset
  in
  match result with
  | Ok _ ->
    Lwt.return
    @@ Response.redirect_to
         ~status:`Found
         ("/datasets/" ^ string_of_int dataset.id ^ "/tasks")
  | Error err ->
    let message =
      match err with
      | `Msg reason ->
        reason
      | `Already_exists ->
        "You already created a dataset with the same name."
      | `Not_found ->
        "The user with the given email could not be found."
      | `Permission_denied ->
        "You do not have the permission to create an annotation task"
      | `Validation_error err ->
        err
      | `Internal_error _ ->
        "An internal error occured."
    in
    let* definitions =
      Sapiens_backend.Dataset.get_dataset_feature_definitions ~as_:user dataset
    in
    (match definitions with
    | Ok definitions ->
      Lwt.return
      @@ Response.of_html
           (Dataset_task_view.new_
              ~dataset
              ~user
              ~definitions
              ~alert:(`error message)
              ())
    | Error _ ->
      (* This should never happen: if the user can index the dataset, it should
         be able to index its feature definitions. *)
      halt Common.Response.internal_error)

let cancel_task req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* task_id =
      Common.Request.decode_param
        ~decoder:(fun s ->
          match int_of_string_opt s with
          | Some i ->
            Ok i
          | None ->
            Error (`Msg "The task ID is invalid"))
        "task_id"
        req
    in
    let* task =
      Sapiens_backend.Annotation.get_annotation_task_by_id ~as_:user task_id
    in
    Sapiens_backend.Annotation.cancel_annotation_task ~as_:user task
  in
  match result with
  | Ok _ ->
    Response.redirect_to
      ~status:`Found
      ("/datasets/" ^ string_of_int dataset.id ^ "/tasks")
    |> Flash.set_success "The task has been canceled successfully."
    |> Lwt.return
  | Error err ->
    let message =
      match err with
      | `Msg message ->
        message
      | `Not_in_progress ->
        "The task is not in progress, it can't be canceled."
      | `Not_found ->
        "The annotation task could not be found."
      | `Permission_denied ->
        "You do not have the permission to cancel an annotation task"
      | `Internal_error _ ->
        "An internal error occured."
    in
    Response.redirect_to
      ~status:`Found
      ("/datasets/" ^ string_of_int dataset.id ^ "/tasks")
    |> Flash.set_error message
    |> Lwt.return

let complete_task req =
  let* dataset = get_dataset_or_halt req in
  let user = Context.find_exn User_auth_middleware.Env.key req.Request.env in
  let* result =
    let open Lwt_result.Syntax in
    let* task_id =
      Common.Request.decode_param
        ~decoder:(fun s ->
          match int_of_string_opt s with
          | Some i ->
            Ok i
          | None ->
            Error (`Msg "The task ID is invalid"))
        "task_id"
        req
    in
    let* task =
      Sapiens_backend.Annotation.get_annotation_task_by_id ~as_:user task_id
    in
    Sapiens_backend.Annotation.complete_annotation_task ~as_:user task
  in
  match result with
  | Ok _ ->
    Response.redirect_to
      ~status:`Found
      ("/datasets/" ^ string_of_int dataset.id ^ "/tasks")
    |> Flash.set_success "The task has been canceled successfully."
    |> Lwt.return
  | Error err ->
    let message =
      match err with
      | `Msg message ->
        message
      | `Not_in_progress ->
        "The task is not in progress, it can't be completed."
      | `Not_found ->
        "The annotation task could not be found."
      | `Permission_denied ->
        "You do not have the permission to cancel an annotation task"
      | `Internal_error _ ->
        "An internal error occured."
    in
    Response.redirect_to
      ~status:`Found
      ("/datasets/" ^ string_of_int dataset.id ^ "/tasks")
    |> Flash.set_error message
    |> Lwt.return
