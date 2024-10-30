module State : sig
  type t =
    | In_progress
    | Completed
    | Canceled
  [@@deriving show]

  val t : t Caqti_type.t
end

module Name : Helper.STRING_FIELD

type t =
  { id : int
  ; name : Name.t
  ; guidelines_url : string option
  ; creator_id : int
  ; dataset_id : int
  ; input_features : Dataset_datapoint.definition list
  ; output_features : Dataset_datapoint.definition list
  ; state : State.t
  ; created_at : Ptime.t
  }
[@@deriving show]

val get_by_id
  :  int
  -> (t, [> `Internal_error of string | `Not_found ]) result Lwt.t

val get_by_user_id
  :  ?state:State.t
  -> int
  -> (t list, [> `Internal_error of string ]) result Lwt.t

val get_by_dataset_id
  :  ?state:State.t
  -> int
  -> (t list, [> `Internal_error of string ]) result Lwt.t

val create
  :  name:Name.t
  -> creator:Account_user.t
  -> dataset:Dataset_dataset.t
  -> input_feature_ids:int list
  -> output_feature_ids:int list
  -> ?guidelines_url:string
  -> unit
  -> (t, [> `Internal_error of string ]) result Lwt.t

val complete : t -> (unit, [> `Internal_error of string ]) result Lwt.t

val cancel : t -> (unit, [> `Internal_error of string ]) result Lwt.t
