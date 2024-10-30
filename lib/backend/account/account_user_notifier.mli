module type S = sig
  val deliver_confirmation_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver instructions to confirm account. *)

  val deliver_reset_password_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver instructions to reset password account. *)

  val deliver_update_email_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver instructions to update your e-mail. *)

  val deliver_deleted_account_email
    :  Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver account deletion confirmation e-mail *)
end

module Console : S

module Email : S
