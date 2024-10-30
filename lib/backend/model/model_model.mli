module Query : sig
  type t [@@deriving show, eq]

  val of_string : string -> t

  val to_string : t -> string

  val t : t Caqti_type.t
end

module Name : sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val to_string : t -> string

  val t : t Caqti_type.t
end

module Description : sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val to_string : t -> string

  val t : t Caqti_type.t
end

type t =
  { id : int
  ; name : Name.t
  ; description : Description.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving show, eq]

val get_all : unit -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get all the models. *)

val get_by_user
  :  Account.User.t
  -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get the models associated to the user. *)

val get_by_id
  :  int
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a model by id. *)

val create
  :  user:Account.User.t
  -> name:Name.t
  -> ?description:Description.t
  -> unit
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Create a new model with the name [name]. *)

val update
  :  ?name:Name.t
  -> ?description:Description.t
  -> t
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Update the model with [name]. *)

val delete : t -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete the model. *)

val search : Query.t -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Search all models matching the query. *)
