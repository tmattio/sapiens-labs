module Make_field (M : sig
  [@@@warning "-32"]

  type t [@@deriving show, eq]

  val validate : t -> (t, [> `Validation_error of string ]) result

  val caqti_type : t Caqti_type.t
end) =
struct
  open Std.Result.Syntax

  type t = M.t [@@deriving show, eq]

  let validate = M.validate

  let of_string s =
    let+ _result = validate s in
    s

  let to_string s = s

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok (to_string x))
        M.caqti_type)
end

module type STRING_FIELD = sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val to_string : t -> string

  val t : t Caqti_type.t
end

let validate_string_length ?min ?max ~name s =
  let open Std.Result.Syntax in
  let* _ =
    match max with
    | Some max ->
      if String.length s <= max then
        Ok s
      else
        Error
          (`Validation_error
            (Printf.sprintf
               "The %s must contain at most %d characters"
               name
               max))
    | None ->
      Ok s
  in
  match min with
  | Some min ->
    if String.length s >= min then
      Ok s
    else
      Error
        (`Validation_error
          (Printf.sprintf "The %s must contain at least %d characters" name min))
  | None ->
    Ok s
