module Username : sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val to_string : t -> string

  val t : t Caqti_type.t
end

module Email : sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val to_string : t -> string

  val t : t Caqti_type.t
end

module Password : sig
  type t [@@deriving show, eq]

  val of_string : string -> (t, [> `Validation_error of string ]) result

  val t : t Caqti_type.t

  val hash : ?count:int -> t -> t
  (** Hash the password the the bcrypt algorithm *)

  val verify : hash:t -> plain:t -> bool
  (** Verify that a hashed password an a password in plain text have the same
      value *)
end

type t =
  { id : int
  ; hashed_password : Password.t
  ; username : Username.t
  ; email : Email.t
  ; confirmed_at : Ptime.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving sexp_of, show, eq, make]

val is_password_valid : password:Password.t -> t -> bool
(** Verifies the password.

    Returns the given user if valid, If there is no user or the user doesn't
    have a password, we still run the password hash function with a blank
    password to avoid timing attacks. *)

val get_all : unit -> (t list, [> `Internal_error of string ]) Lwt_result.t
(** Get all the users. *)

val get_by_id
  :  int
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a user by id. *)

val get_by_username
  :  Username.t
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a user by username. *)

val get_by_email
  :  Email.t
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a user by email. *)

val get_by_email_and_password
  :  email:Email.t
  -> password:Password.t
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Get a user by email and password. *)

val create
  :  username:Username.t
  -> email:Email.t
  -> password:Password.t
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Create a new user with the name [name]. *)

val update
  :  ?username:Username.t
  -> ?email:Email.t
  -> ?password:Password.t
  -> t
  -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Update the user with [name]. *)

val delete : t -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete the user. *)
