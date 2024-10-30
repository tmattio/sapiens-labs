val html
  :  ?custom_handler:(Opium.Status.t -> Opium.Response.t Lwt.t option)
  -> unit
  -> Rock.Middleware.t

val json
  :  ?custom_handler:(Opium.Status.t -> Opium.Response.t Lwt.t option)
  -> unit
  -> Rock.Middleware.t
