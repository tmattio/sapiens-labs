module Ptime = struct
  include Ptime

  let to_yojson t = `String (Ptime.to_rfc3339 t)

  let of_yojson json =
    match json with
    | `String s ->
      (match Ptime.of_rfc3339 s with
      | Ok (d, _, _) ->
        Ok d
      | _ ->
        Error "could not decode the RFC3339 date")
    | _ ->
      Error "the json is not a string"
end

module Annotation = struct
  type t =
    { id : int
    ; user_id : int
    ; annotation_task_id : int
    ; datapoint_id : int
    ; input_features : Datapoint.feature list
    ; annotations : Datapoint.feature list
    ; annotated_at : Ptime.t option
    }
  [@@deriving show, yojson]
end

type user_annotation_task =
  { name : string
  ; guidelines : string option
  ; input_definitions : Datapoint.definition list
  ; output_definitions : Datapoint.definition list
  ; annotations : Annotation.t list
  }
[@@deriving show, yojson]

type user_annotation =
  { datapoint_id : int
  ; annotations : Datapoint.feature list
  }
[@@deriving show, yojson]

type user_annotation_response =
  | Ok
  | Error of string
[@@deriving show, yojson]
