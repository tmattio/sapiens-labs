module Query : sig
  type t [@@deriving show, eq]

  val of_string : string -> t

  val to_string : t -> string

  val t : t Caqti_type.t
end

module Name : Helper.STRING_FIELD

module Description : Helper.STRING_FIELD

module Homepage : Helper.STRING_FIELD

module Citation : Helper.STRING_FIELD

type t =
  { id : int
  ; user : Account.User.t
  ; collaborators : Account.User.t list
  ; name : Name.t
  ; is_public : bool
  ; description : Description.t option
  ; homepage : Homepage.t option
  ; citation : Citation.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving show, eq, make]

val get_all : unit -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get all the datasets. *)

val get_by_user
  :  Account.User.t
  -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get the datasets associated to the user. *)

val get_shared_by_user
  :  Account.User.t
  -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get the datasets associated or shared to the user. *)

val get_by_name_and_username
  :  name:Name.t
  -> username:Account_user.Username.t
  -> (t, [> `Internal_error of string | `Not_found ]) result Lwt.t
(** Get a dataset by its name and the username of its owner *)

val get_by_id
  :  int
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a dataset by id. *)

val create
  :  user:Account.User.t
  -> name:Name.t
  -> ?description:Description.t
  -> ?homepage:Homepage.t
  -> ?citation:Citation.t
  -> ?is_public:bool
  -> unit
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Create a new dataset with the name [name]. *)

val update
  :  ?name:Name.t
  -> ?description:Description.t
  -> ?homepage:Homepage.t
  -> ?citation:Citation.t
  -> ?is_public:bool
  -> t
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Update the dataset with [name]. *)

val update_owner
  :  Account_user.t
  -> t
  -> (t, [> `Internal_error of string ]) result Lwt.t
(** Update the dataset owner *)

val delete : t -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete the dataset. *)

val search : Query.t -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Search all datasets matching the query. *)
