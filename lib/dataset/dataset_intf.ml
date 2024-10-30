open Sapiens_backend.Dataset.Datapoint

module type S = sig
  val name : string

  val guidelines : string option

  val definitions : (string * definition_spec) list

  val make_datapoints
    :  definition_spec persisted_definition list
    -> feature list list

  val collaborators : (string * string) list option

  val tasks : (string * string * string list * string list) list option
end
