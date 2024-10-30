(** Entrypoint to Sapiens' web library. *)

module Cookies = Cookies

module Middleware = struct
  include Opium.Middleware

  let static =
    static
      ~read:(fun fname ->
        match Asset.read fname with
        | None ->
          Lwt.return @@ Error `Not_found
        | Some body ->
          Lwt.return @@ Ok (Opium.Body.of_string body))
      ~etag_of_fname:(fun fname ->
        match Asset.read fname with
        | None ->
          None
        | Some body ->
          Some
            (body
            |> Cstruct.of_string
            |> Mirage_crypto.Hash.digest `MD5
            |> Cstruct.to_string
            |> Base64.encode_exn))
      ()

  let error_handler =
    Error_handler_middleware.html
      ~custom_handler:(function
        | status ->
          let view = Error_view.fallback ~status in
          Some (Lwt.return @@ Opium.Response.of_html view))
      ()

  let require_authenticated_user =
    User_auth_middleware.require_authenticated_user

  let redirect_if_user_is_authenticated =
    User_auth_middleware.redirect_if_user_is_authenticated

  let fetch_current_user = User_auth_middleware.fetch_current_user

  let logger =
    Middleware_logger.m
      ~time_f:(fun f ->
        let t1 = Mtime_clock.now () in
        let x = f () in
        let t2 = Mtime_clock.now () in
        let span = Mtime.span t1 t2 in
        span, x)
      ()

  let flash = Middleware_flash.m ()
end

module Handler = struct
  module Page = Page_handler
  module User_auth = User_auth_handler
  module User_confirmation = User_confirmation_handler
  module User_registration = User_registration_handler
  module User_reset_password = User_reset_password_handler
  module User_session = User_session_handler
  module User_settings = User_settings_handler
end

(** [handler] is the server default handler.

    When a request is received, it is piped through the middlewares and
    eventually gets routed to the appropriate handler by the router middleware
    [Router.m]. In the case where the router middleware fails to match the
    request with a route, the default handler is used a fallback. In our case,
    every route that is not handled by the server will be handled by the
    frontend application. *)
let handler _req =
  Lwt.return
  @@ Opium.Response.of_html
       (Error_view.fallback ~status:`Not_found)
       ~status:`Not_found

(** [middlewares] is the list of middlewares used by every endpoints of the
    application's API.

    Most of the time, middlewares are scoped to a set of routes. Scoped
    middlewares should be added to the router ([Router.m]). But in situation
    where you want to pipe every incoming requests through a middleware (e.g. to
    globally reject a User-Agent), you can add the middleware to this list. *)
let middlewares =
  [ (* The router of the application. It will try to match the requested URI
       with one of the defined route. If it finds a match, it will call the
       appropriate handler. If no route is found, it will call the default
       handler. *)
    Middleware.router Router.router
  ; Middleware.method_override
  ; (* Add Content-Length header *)
    Middleware.content_length
  ; Middleware.flash
  ]

let middlewares =
  if Sapiens_backend.Config.is_prod then
    [ (* Serving static files *) Middleware.static; Middleware.error_handler ]
    @ middlewares
  else
    [ Middleware.static_unix ~local_path:"_build/default/asset" ()
    ; Middleware.allow_cors
        ~origins:[ "http://localhost:8080"; "http://localhost:3000" ]
        ()
    ]
    @ middlewares

(** [app] represents our web application as list of middleware and an handler.

    It is meant to be used from an Httpaf server. If you're using Unix as a
    backend, you can convert the app from a [Rock.App] to an [Opium.App] and
    serve it with [Opium.App.run_command] *)
let app =
  let app = Opium.App.empty in
  ListLabels.fold_right middlewares ~init:app ~f:(fun m app ->
      Opium.App.middleware m app)
  |> Opium.App.not_found (fun req ->
         let open Lwt.Syntax in
         let+ resp = handler req in
         let headers = resp.headers in
         let body = resp.body in
         headers, body)
  |> Opium.App.cmd_name "Sapiens"
