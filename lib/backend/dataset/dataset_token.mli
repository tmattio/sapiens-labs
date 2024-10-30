module Context : sig
  type t =
    | Invite_collaborator
    | Transfer
  [@@deriving show, eq]

  val t : t Caqti_type.t
end

type t =
  { token : Token.t
  ; user_id : int
  ; dataset_id : int
  ; context : Context.t
  ; sent_to : Account.User.Email.t
  }
[@@deriving show, eq]

val build_invitation_token
  :  Account.User.t
  -> Dataset_dataset.t
  -> (Token.t * t, [> `Internal_error of string ]) result
(** Builds a token with a hashed counter part.

    The non-hashed token is sent to the user e-mail while the hashed part is
    stored in the database, to avoid reconstruction. The token is valid for a
    week as long as users don't change their email. *)

val build_transfer_token
  :  Account.User.t
  -> Dataset_dataset.t
  -> (Token.t * t, [> `Internal_error of string ]) result
(** Builds a token with a hashed counter part.

    The non-hashed token is sent to the user e-mail while the hashed part is
    stored in the database, to avoid reconstruction. The token is valid for a
    week as long as users don't change their email. *)

val verify_invitation_token
  :  Token.t
  -> ( Account_user.t * Dataset_dataset.t
     , [> `Internal_error of string | `Not_found ] )
     Lwt_result.t
(** Checks if the token is valid and returns the dataset. *)

val verify_transfer_token
  :  Token.t
  -> ( Account_user.t * Dataset_dataset.t
     , [> `Internal_error of string | `Not_found ] )
     Lwt_result.t
(** Checks if the token is valid and returns the dataset. *)

val insert : t -> (t, [> `Internal_error of string ]) Lwt_result.t
(** Insert a user token in the database *)

val get_by_token
  :  ?context:Context.t
  -> Token.t
  -> (t, [> `Not_found | `Internal_error of string ]) Lwt_result.t
(** Get a user token from a token string.

    The given token must not be hashed or encoded. *)

val delete_by_token
  :  ?context:Context.t
  -> Token.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Delete user tokens by token.

    If [context] is passed, only the tokens with the given context will be
    deleted. *)

val get_all_invitations
  :  Dataset_dataset.t
  -> (t list, [> `Internal_error of string ]) result Lwt.t
(** ??? *)

val get_transfer
  :  Dataset_dataset.t
  -> (t, [> `Internal_error of string | `Not_found ]) result Lwt.t
(** ??? *)

val get_transfer_opt
  :  Dataset_dataset.t
  -> (t option, [> `Internal_error of string ]) result Lwt.t
(** ??? *)

val get_invitation_by_user_id
  :  int
  -> Dataset_dataset.t
  -> (t, [> `Internal_error of string | `Not_found ]) result Lwt.t
(** ??? *)

val get_transfer_by_user_id
  :  int
  -> Dataset_dataset.t
  -> (t, [> `Internal_error of string | `Not_found ]) result Lwt.t
(** ??? *)
