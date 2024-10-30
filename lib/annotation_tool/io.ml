let get_annotation_task task_id =
  let headers =
    Brr_io.Fetch.Headers.of_assoc [ Jstr.v "Accept", Jstr.v "application/json" ]
  in
  let init =
    Brr_io.Fetch.Request.init ~headers ~credentials:(Jstr.v "include") ()
  in
  let request =
    Brr_io.Fetch.Request.v
      ~init
      (Jstr.v (Config.url ^ "tasks/" ^ string_of_int task_id))
  in
  let response = Brr_io.Fetch.request request in
  response

let send_annotations ~callback task_id annotations =
  let headers =
    Brr_io.Fetch.Headers.of_assoc
      [ Jstr.v "Accept", Jstr.v "application/json"
      ; Jstr.v "Content-Type", Jstr.v "application/json"
      ]
  in
  let body = Brr_io.Fetch.Body.of_jstr (Jstr.v annotations) in
  let init =
    Brr_io.Fetch.Request.init
      ~body
      ~headers
      ~credentials:(Jstr.v "include")
      ~method':(Jstr.v "POST")
      ()
  in
  let request =
    Brr_io.Fetch.Request.v
      ~init
      (Jstr.v (Config.url ^ "tasks/" ^ string_of_int task_id))
  in
  let fut =
    let open Fut.Syntax in
    let* response = Brr_io.Fetch.request request in
    match response with
    | Ok response ->
      let* body =
        Brr_io.Fetch.Response.as_body response |> Brr_io.Fetch.Body.text
      in
      (match body with
      | Ok body ->
        let json = Jstr.to_string body |> Yojson.Safe.from_string in
        Fut.return
        @@
        (match
           Sapiens_common.Annotation.user_annotation_response_of_yojson json
         with
        | Ok Sapiens_common.Annotation.Ok ->
          Ok ()
        | Ok (Error err) ->
          Error err
        | Error err ->
          Error err)
      | Error error ->
        Fut.return @@ Error (Jv.Error.message error |> Jstr.to_string))
    | Error error ->
      Fut.return @@ Error (Jv.Error.message error |> Jstr.to_string)
  in
  Fut.await fut callback
