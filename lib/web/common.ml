open Opium

module Request = struct
  let decode_param ~decoder key req =
    let open Lwt_result.Syntax in
    let* field =
      Request.urlencoded key req
      |> Lwt.map
           (Option.to_result
              ~none:(`Msg ("The field " ^ key ^ " is required.")))
    in
    let+ field = decoder field |> Lwt_result.lift in
    field

  let decode_param_opt ~decoder key req =
    let open Lwt_result.Syntax in
    let* field = Request.urlencoded key req |> Lwt_result.ok in
    match field with
    | Some value ->
      (match decoder value with
      | Ok value ->
        Ok (Some value) |> Lwt_result.lift
      | Error err ->
        Error err |> Lwt.return)
    | None ->
      Lwt.return_ok None
end

module Response = struct
  let not_found =
    Opium.Response.of_html
      (Error_view.fallback ~status:`Not_found)
      ~status:`Not_found

  let internal_error =
    Opium.Response.of_html
      (Error_view.fallback ~status:`Internal_server_error)
      ~status:`Internal_server_error
end
