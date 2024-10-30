val get_all
  :  Dataset_dataset.t
  -> (Account.User.t list, [> `Internal_error of string ]) Lwt_result.t
(** Get all the dataset collaborators. *)

val add
  :  Account.User.t
  -> Dataset_dataset.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Add a new dataset collaborator. *)

val remove
  :  Account.User.t
  -> Dataset_dataset.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Remove a dataset collaborator. *)
