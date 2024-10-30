open Opium

let index req =
  let user_opt = Context.find User_auth_middleware.Env.key req.Request.env in
  match user_opt with
  | Some _ ->
    Dataset_handler.index req
  | None ->
    Lwt.return @@ Response.of_html (Page_landing_view.make ())

let about _req = Lwt.return @@ Response.of_html (Page_about_view.make ())

let jobs _req = Lwt.return @@ Response.of_html (Page_jobs_view.make ())

let features_analytics _req =
  Lwt.return @@ Response.of_html (Page_view.features_analytics ())

let features_annotation _req =
  Lwt.return @@ Response.of_html (Page_view.features_annotation ())

let features_model_training _req =
  Lwt.return @@ Response.of_html (Page_view.features_model_training ())

let features_model_deployment _req =
  Lwt.return @@ Response.of_html (Page_view.features_model_deployment ())

let pricing _req = Lwt.return @@ Response.of_html (Page_pricing_view.make ())

let consulting _req =
  Lwt.return @@ Response.of_html (Page_consulting_view.make ())

let terms _req = Lwt.return @@ Response.of_html (Page_view.terms ())

let privacy _req = Lwt.return @@ Response.of_html (Page_view.privacy ())
