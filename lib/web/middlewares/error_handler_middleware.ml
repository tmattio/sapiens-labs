(** [Error_handler] creates error HTML pages for standard HTTP errors. Any
    exception thrown by the handler will be caught and will be converted to a
    response with the status Internal Server Error (HTTP code 500).

    {4 Overriding Error}

    To override an error, a [custom_handler] can be passed. The following
    example override the handling of the "Forbidden" error.

    {[
      let custom_handler = function
        | `Forbidden ->
          Some (Response.of_plain_text "Denied!")
        | _ ->
          None

      let error_handler = Middleware.error_handler ~custom_handler ()
    ]} *)

open Opium

let log_src = Logs.Src.create "opium.server"

let m ?custom_handler ?(name = "Error Handler") ~make_response () =
  let open Lwt.Syntax in
  let filter handler req =
    let* response =
      Lwt.catch
        (fun () -> handler req)
        (fun exn ->
          Logs.err ~src:log_src (fun f -> f "%s" (Printexc.to_string exn));
          Lwt.return Common.Response.internal_error)
    in
    match Httpaf.Status.is_error response.status with
    | true ->
      (match Option.bind custom_handler (fun f -> f response.status) with
      | Some r ->
        r
      | None ->
        make_response response)
    | false ->
      Lwt.return response
  in
  Rock.Middleware.create ~name ~filter

module Html = struct
  let style =
    {|/*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body,h2{margin:0}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}h2{font-size:inherit;font-weight:inherit}.font-semibold{font-weight:600}.text-2xl{font-size:1.5rem}.leading-8{line-height:2rem}.mx-auto{margin-left:auto;margin-right:auto}.mt-0{margin-top:0}.mb-4{margin-bottom:1rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}@media (min-width:640px){.sm\:text-3xl{font-size:1.875rem}.sm\:leading-9{line-height:2.25rem}.sm\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\:py-8{padding-top:2rem;padding-bottom:2rem}}@media (min-width:1024px){.lg\:px-8{padding-left:2rem;padding-right:2rem}}|}

  let format_error error code message =
    Format.asprintf
      {|
    <!doctype html>
    <html lang="en">
    
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>%s</title>
      <style>
        %s
      </style>
    </head>
    
    <body class="antialiased">
      <div class="py-4 sm:py-8">
        <div class="max-w-8xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 class="text-2xl leading-8 font-semibold font-display text-gray-900 sm:text-3xl sm:leading-9">
            %d %s
          </h2>
          <div class="mt-0 mb-4 text-gray-600">
            %s
          </div>
        </div>
      </div>
    </body>
    
    </html>
        |}
      error
      style
      code
      error
      message

  let m ?custom_handler () =
    m
      ?custom_handler
      ~name:"HTML Error Handler"
      ~make_response:(fun response ->
        let code = Httpaf.Status.to_code response.status in
        let error = Opium.Status.default_reason_phrase response.status in
        let message = Opium.Status.long_reason_phrase response.status in
        let body = format_error error code message |> Body.of_string in
        Response.make ~body ~status:response.status () |> Lwt.return)
      ()
end

let html = Html.m

module Json = struct
  module Error = struct
    type t =
      { status : int
      ; error : string
      ; message : string
      }

    let to_yojson { status; error; message } =
      `Assoc
        [ "status", `Int status
        ; "error", `String error
        ; "message", `String message
        ]
  end

  let m ?custom_handler () =
    m
      ?custom_handler
      ~name:"JSON Error Handler"
      ~make_response:(fun response ->
        let code = Httpaf.Status.to_code response.status in
        let error = Opium.Status.default_reason_phrase response.status in
        let message = Opium.Status.long_reason_phrase response.status in
        let error =
          Error.{ status = code; error; message } |> Error.to_yojson
        in
        Response.of_json error |> Lwt.return)
      ()
end

let json = Json.m
