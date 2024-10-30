(** The Account context. *)

module Error : sig
  type t =
    [ `Already_exists
    | `Already_confirmed
    | `Invalid_password
    | Error.t
    ]
  [@@deriving show, eq]
end

module User = Account_user
module User_token = Account_user_token

(* Database getters *)

val get_user_by_email
  :  User.Email.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets a user by email.

    {4 Examples}

    {[
      get_user_by_email "foo@example.com"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      get_user_by_email "unknown@example.com"
      _ : (User.t, string) Lwt_result.t = Error "not found"
    ]} *)

val get_user_by_username
  :  User.Username.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets a user by email.

    {4 Examples}

    {[
      get_user_by_username "user"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      get_user_by_username "invalid_user"
      _ : (User.t, string) Lwt_result.t = Error "not found"
    ]} *)

val get_user_by_email_and_password
  :  email:User.Email.t
  -> password:User.Password.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets a user by email and password.

    {4 Examples}

    {[
      get_user_by_email_and_password ~email:"foo@example.com" ~password:"correct_password"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      get_user_by_email_and_password ~email:"unknown@example.com" ~password:"invalid_password"
      _ : (User.t, string) Lwt_result.t = Error "invalid password"
    ]} *)

val get_user_by_id
  :  int
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets a user by ID.

    {4 Examples}

    {[
      get_user_by_id 123
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      get_user_by_id 456
      _ : (User.t, string) Lwt_result.t = Error "not found"
    ]} *)

val register_user
  :  username:User.Username.t
  -> email:User.Email.t
  -> password:User.Password.t
  -> (User.t, [> `Already_exists | `Internal_error of string ]) Lwt_result.t
(** Registers a user.

    It is important to validate the length of both e-mail and password.
    Otherwise databases may truncate the e-mail without warnings, which could
    lead to unpredictable or insecure behaviour. Long passwords may also be very
    expensive to hash for certain algorithms.

    {4 Examples}

    {[
      register_user ~email ~password
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      register_user ~email ~password
      _ : (User.t, string) Lwt_result.t = Error "invalid user"
    ]} *)

(* Settings *)

val update_user_email
  :  token:Token.t
  -> User.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Updates the user e-mail in token.

    Returns the updated user.

    If the token matches, the user email is updated and the token is deleted.
    The confirmed_at date is also updated to the current time. *)

val deliver_update_email_instructions
  :  email:User.Email.t
  -> password:User.Password.t
  -> update_email_url_fn:(string -> string)
  -> User.t
  -> ( User.Email.t * string
     , [> `Already_exists
       | `Internal_error of string
       | `Invalid_password
       | `Validation_error of string
       ] )
     Lwt_result.t
(** Delivers the update e-mail instructions to the given user. *)

val update_user_password
  :  current_password:User.Password.t
  -> new_password:User.Password.t
  -> User.t
  -> (User.t, [> `Internal_error of string | `Invalid_password ]) Lwt_result.t
(** Updates the user password.

    {4 Examples}

    {[
      update_user_password user ~password:"valid password"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      update_user_password user ~password:"invalid password"
      _ : (User.t, string) Lwt_result.t = Error "invalid password"
    ]} *)

(* Session *)

val generate_session_token
  :  User.t
  -> (Token.t, [> `Internal_error of string ]) Lwt_result.t

(** Generates a session token. *)

val get_user_by_session_token
  :  Token.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t

(** Gets the user with the given signed token. *)

val delete_session_token
  :  Token.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t

(** Deletes the signed token with the given context. *)

(* Confirmation *)

val deliver_user_confirmation_instructions
  :  confirmation_url_fn:(string -> string)
  -> User.t
  -> ( User.Email.t * string
     , [> `Already_confirmed | `Internal_error of string ] )
     Lwt_result.t
(** Delivers the confirmation e-mail instructions to the given user. *)

val confirm_user
  :  Token.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Confirms a user by the given token.

    If the token matches, the user account is marked as confirmed and the token
    is deleted. *)

(* Reset password *)

val deliver_user_reset_password_instructions
  :  reset_password_url_fn:(string -> string)
  -> User.t
  -> (User.Email.t * string, [> `Internal_error of string ]) Lwt_result.t
(** Delivers the reset password e-mail to the given user. *)

val get_user_by_reset_password_token
  :  Token.t
  -> (User.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets the user by reset password token.

    {4 Examples}

    {[
      get_user_by_reset_password_token "validtoken"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      get_user_by_reset_password_token "invalidtoken"
      _ : (User.t, string) Lwt_result.t = Error "invalid token"
    ]} *)

val reset_user_password
  :  password:User.Password.t
  -> password_confirmation:User.Password.t
  -> User.t
  -> ( User.t
     , [> `Internal_error of string | `Validation_error of string ] )
     Lwt_result.t
(** Resets the user password.

    {4 Examples}

    {[
      reset_user_password user ~password:"new password" ~password_confirmation:"new password"
      _ : (User.t, string) Lwt_result.t = Ok { name = "Tom" ; age = 25 }

      reset_user_password user ~password:"valid" ~password_confirmation:"not the same"
      _ : (User.t, string) Lwt_result.t = Error "passwords do not match"
    ]} *)

val delete_user
  :  password:User.Password.t
  -> User.t
  -> (unit, [> `Internal_error of string | `Invalid_password ]) Lwt_result.t
(** Deletes a user.

    {4 Examples}

    {[
      delete_user user
      _ : (unit, [> `Internal_error of string | `Invalid_password ]) Lwt_result.t = Ok { id = 123 ; _ }

      delete_user user
      _ : (unit, [> `Internal_error of string | `Invalid_password ]) Lwt_result.t = Error _
    ]} *)
