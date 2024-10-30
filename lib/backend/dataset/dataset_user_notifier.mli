module type S = sig
  val deliver_invitation_instructions
    :  url:string
    -> inviter:Account_user.t
    -> dataset:Dataset_dataset.t
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver instructions to accept a dataset invitation. *)

  val deliver_transfer_instructions
    :  url:string
    -> inviter:Account_user.t
    -> dataset:Dataset_dataset.t
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
  (** Deliver instructions to accept a dataset transfer. *)
end

module Console : S

module Email : S
