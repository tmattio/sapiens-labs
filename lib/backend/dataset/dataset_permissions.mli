type action =
  [ `Index_dataset
  | `Update_dataset
  | `Transfer_dataset
  | `Delete_dataset
  | `Add_collaborator
  | `Remove_collaborator
  | `Upload_dataset
  | `Create_annotation_task
  | `Cancel_annotation_task
  | `Complete_annotation_task
  ]

val can : Account.User.t -> action -> Dataset_dataset.t -> bool
(** [can user action dataset] returns [true] if the user [user] can perform the
    action [action] on the dataset [dataset], or [false] if not. *)
