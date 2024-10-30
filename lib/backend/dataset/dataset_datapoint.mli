include module type of struct
  include Sapiens_common.Datapoint
end

module Feature_type : sig
  include module type of Feature_type

  val t : t Caqti_type.t
end

module Feature_name : sig
  include module type of Feature_name

  val t : t Caqti_type.t
end

module Split : sig
  include module type of Feature_name

  val t : t Caqti_type.t
end

val get_by_dataset
  :  ?limit:int
  -> ?offset:int
  -> ?split:Split.t
  -> Dataset_dataset.t
  -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get the datapoints associated with dataset. *)

val get_by_id
  :  int
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a datapoint by id. *)

val create
  :  dataset:Dataset_dataset.t
  -> features:feature list
  -> ?split:Split.t
  -> unit
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Create a new datapoint. *)

val delete : t -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Create a new datapoint. *)

val get_definitions_by_dataset
  :  Dataset_dataset.t
  -> (definition list, [> `Internal_error of string ]) Lwt_result.t
(** Get the dataset feature definition associated to the dataset. *)

val get_definition_by_id
  :  int
  -> (definition, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a dataset feature definition by id. *)

val create_definition
  :  dataset:Dataset_dataset.t
  -> name:Feature_name.t
  -> definition_spec
  -> (definition, [> `Internal_error of string ]) Lwt_result.t
(** Create a new dataset feature definition. *)

val create_definitions_in_batch
  :  dataset:Dataset_dataset.t
  -> (string * definition_spec) list
  -> (unit, [> `Internal_error of string ]) result Lwt.t
(** Create new dataset feature definitions in batch. *)

val update_definition
  :  ?name:Feature_name.t
  -> ?spec:definition_spec
  -> definition
  -> (definition, [> `Internal_error of string ]) Lwt_result.t
(** Update the dataset feature definition. *)

val delete_definition
  :  definition
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete the dataset feature definition. *)

val update_datapoints_features
  :  (int * feature list) list
  -> (unit, [> `Internal_error of string ]) result Lwt.t
