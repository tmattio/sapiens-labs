module Env : sig
  val key : Sapiens_backend.Account.User.t Opium.Context.key
end

val require_authenticated_user : Rock.Middleware.t
(** Used for routes that require the user to be authenticated.

    If you want to enforce the user e-mail is confirmed before they use the
    application at all, here would be a good place. *)

val redirect_if_user_is_authenticated : Rock.Middleware.t
(** Used for routes that require the user to not be authenticated. *)

val fetch_current_user : Rock.Middleware.t
(** Authenticates the user by looking into the session and remember me token. *)
