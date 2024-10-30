type t =
  [ `Already_exists
  | `Permission_denied
  | `Not_found
  | `Internal_error of string
  | `Validation_error of string
  ]
[@@deriving show, eq]
