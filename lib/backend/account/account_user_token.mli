module Context : sig
  type t =
    | Confirm
    | Reset_password
    | Session
    | Change_email of Account_user.Email.t
  [@@deriving show, eq]

  val t : t Caqti_type.t
end

type t =
  { token : Token.t
  ; user_id : int
  ; context : Context.t
  ; sent_to : Account_user.Email.t option
  }
[@@deriving show, eq]

val build_session_token
  :  Account_user.t
  -> (Token.t * t, [> `Internal_error of string ]) result
(** Generates a token that will be stored in a signed place, such as session or
    cookie. As they are signed, those tokens do not need to be hashed. *)

val build_email_token
  :  context:Context.t
  -> Account_user.t
  -> (Token.t * t, [> `Internal_error of string ]) result
(** Builds a token with a hashed counter part.

    The non-hashed token is sent to the user e-mail while the hashed part is
    stored in the database, to avoid reconstruction. The token is valid for a
    week as long as users don't change their email. *)

val verify_session_token
  :  Token.t
  -> (Account_user.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Checks if the token is valid and returns the user. *)

val verify_email_token
  :  context:Context.t
  -> Token.t
  -> (Account_user.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Checks if the token is valid and returns the user. *)

val verify_change_email_token
  :  context:Context.t
  -> Token.t
  -> (t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Checks if the token is valid and returns the user. *)

val insert : t -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Insert a user token in the database *)

val get_by_token
  :  ?context:Context.t
  -> Token.t
  -> (t, [> `Not_found | `Internal_error of string ]) Lwt_result.t
(** Get a user token from a token string.

    The given token must not be hashed or encoded. *)

val get_by_user_id
  :  int
  -> (t, [> `Not_found | `Internal_error of string ]) Lwt_result.t
(** Get a user token from a user id. *)

val delete_by_token
  :  ?context:Context.t
  -> Token.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete user tokens by token.

    If [context] is passed, only the tokens with the given context will be
    deleted. *)
