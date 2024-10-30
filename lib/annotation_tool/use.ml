let state x =
  let v = Lwd.var x in
  ( v
  , fun f ->
      let new_v = f (Lwd.peek v) in
      Lwd.set v new_v )

let fetch_task task_id =
  let open Fut.Syntax in
  let s, set_response = state Remote_data.Loading in
  let response = Io.get_annotation_task task_id in
  let _ =
    let* response = response in
    match response with
    | Ok response ->
      (match Brr_io.Fetch.Response.status response with
      | 200 | 204 ->
        let* body =
          Brr_io.Fetch.Response.as_body response |> Brr_io.Fetch.Body.text
        in
        (match body with
        | Ok body ->
          let result = Jstr.to_string body |> Yojson.Safe.from_string in
          set_response (fun _ -> Remote_data.Loaded result);
          Fut.return ()
        | Error error ->
          set_response (fun _ ->
              Error (Jv.Error.message error |> Jstr.to_string));
          Fut.return ())
      | status ->
        set_response (fun _ ->
            Remote_data.Error
              (Printf.sprintf "The server answered with code %d" status));
        Fut.return ())
    | Error error ->
      set_response (fun _ ->
          Remote_data.Error (Jv.Error.message error |> Jstr.to_string));
      Fut.return ()
  in
  s
