(** The Annotation context. *)

module Error : sig
  type t =
    [ `Not_in_progress
    | Error.t
    ]
  [@@deriving show, eq]
end

module Task = Annotation_task
module Annotation = Annotation_annotation

module Progress : sig
  type t =
    { completed : int
    ; total : int
    }

  val compute : t -> float
end

val create_annotation_task
  :  as_:Account_user.t
  -> name:Annotation_task.Name.t
  -> assignee:Account.User.t
  -> datapoint_count:int
  -> input_feature_ids:int list
  -> output_feature_ids:int list
  -> ?guidelines_url:string
  -> Dataset_dataset.t
  -> ( Annotation_task.t
     , [> `Internal_error of string | `Permission_denied ] )
     result
     Lwt.t
(** ??? *)

val get_annotation_task_by_id
  :  as_:Account_user.t
  -> int
  -> ( Annotation_task.t
     , [> `Internal_error of string | `Not_found | `Permission_denied ] )
     result
     Lwt.t
(** ??? *)

val list_user_annotation_tasks
  :  as_:Account_user.t
  -> (Annotation_task.t list, [> `Internal_error of string ]) result Lwt.t
(** ??? *)

val list_dataset_annotation_tasks
  :  as_:Account_user.t
  -> dataset:Dataset_dataset.t
  -> ( Annotation_task.t list
     , [> `Internal_error of string | `Permission_denied ] )
     result
     Lwt.t
(** ??? *)

val cancel_annotation_task
  :  as_:Account_user.t
  -> Annotation_task.t
  -> ( unit
     , [> `Internal_error of string
       | `Not_found
       | `Permission_denied
       | `Not_in_progress
       ] )
     result
     Lwt.t
(** ??? *)

val complete_annotation_task
  :  as_:Account_user.t
  -> Annotation_task.t
  -> ( unit
     , [> `Internal_error of string
       | `Not_found
       | `Permission_denied
       | `Not_in_progress
       ] )
     result
     Lwt.t
(** ??? *)

val annotate_datapoint
  :  user_id:int
  -> annotation_task_id:int
  -> datapoint_id:int
  -> Dataset_datapoint.feature list
  -> (unit, [> `Internal_error of string | `Not_found ]) result Lwt.t
(** ??? *)

val revert_annotation : unit -> unit
(** ??? *)

val get_annotation_tasks_progress
  :  as_:Account_user.t
  -> dataset:Dataset_dataset.t
  -> ( (int * Progress.t) list
     , [> `Internal_error of string | `Permission_denied ] )
     result
     Lwt.t
(** ??? *)

val get_annotation_tasks_user_progress
  :  user:Account_user.t
  -> ((int * Progress.t) list, [> `Internal_error of string ]) result Lwt.t
(** ??? *)

val get_annotation_task_user_annotations
  :  user:Account_user.t
  -> Annotation_task.t
  -> (Annotation.t list, [> `Internal_error of string ]) result Lwt.t
(** ??? *)

val get_annotation_task_annotations
  :  Annotation_task.t
  -> (Annotation.t list, [> `Internal_error of string ]) result Lwt.t
(** ??? *)
