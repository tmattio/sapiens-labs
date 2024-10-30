(** The Dataset context. *)

module Error : sig
  type t =
    [ `Invalid_token
    | Error.t
    ]
  [@@deriving show, eq]
end

module Dataset = Dataset_dataset
module Collabotor = Dataset_collaborator
module Datapoint = Dataset_datapoint
module Dataset_token = Dataset_token

val list_user_datasets
  :  as_:Account.User.t
  -> Account.User.t
  -> (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t
(** Returns the list of datasets of the user.

    {4 Examples}

    {[
      list_user_datasets ()
      _ : (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t = Ok []
    ]} *)

val list_user_shared_datasets
  :  as_:Account.User.t
  -> Account.User.t
  -> (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t
(** Returns the list of datasets of the user.

    {4 Examples}

    {[
      list_user_datasets ()
      _ : (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t = Ok []
    ]} *)

val get_dataset_by_id
  :  as_:Account.User.t
  -> int
  -> ( Dataset.t
     , [> `Internal_error of string | `Not_found | `Permission_denied ] )
     Lwt_result.t
(** Gets a single dataset.

    {4 Examples}

    {[
      get_dataset_by_id 123
      _ : (Dataset.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Ok { id = 123 ; _ }

      get_dataset_by_id 456
      _ : (Dataset.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Error "No results"
    ]} *)

val get_dataset_by_name_and_username
  :  as_:Account.User.t
  -> name:Dataset.Name.t
  -> username:Account.User.Username.t
  -> ( Dataset.t
     , [> `Internal_error of string | `Not_found | `Permission_denied ] )
     Lwt_result.t
(** Get a dataset by its name and the username of its owner.

    {4 Examples}

    {[
      get_by_name_and_username ~username ~name
      _ : (Dataset.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Ok { id = 123 ; _ }

      get_by_name_and_username ~username ~name
      _ : (Dataset.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Error "No results"
    ]} *)

val create_dataset
  :  as_:Account.User.t
  -> name:Dataset.Name.t
  -> ?description:Dataset.Description.t
  -> ?homepage:Dataset.Homepage.t
  -> ?citation:Dataset.Citation.t
  -> ?is_public:bool
  -> unit
  -> (Dataset.t, [> `Already_exists | `Internal_error of string ]) Lwt_result.t
(** Gets a single dataset.

    {4 Examples}

    {[
      create_dataset ~name:"valid"
      _ : (Dataset.t, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      create_dataset ~name:"invalid"
      _ : (Dataset.t, [> `Internal_error of string ]) Lwt_result.t = Error "invalid name"
    ]} *)

val update_dataset
  :  as_:Account.User.t
  -> ?name:Dataset.Name.t
  -> ?description:Dataset.Description.t
  -> ?homepage:Dataset.Homepage.t
  -> ?citation:Dataset.Citation.t
  -> ?is_public:bool
  -> Dataset.t
  -> ( Dataset.t
     , [> `Already_exists | `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Updates a dataset.

    {4 Examples}

    {[
      update_dataset ~name:"valid" dataset
      _ : (Dataset.t, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      update_dataset ~name:"invalid" dataset
      _ : (Dataset.t, [> `Internal_error of string ]) Lwt_result.t = Error "invalid name"
    ]} *)

val delete_dataset
  :  as_:Account.User.t
  -> Dataset.t
  -> (unit, [> `Internal_error of string | `Permission_denied ]) Lwt_result.t
(** Deletes a dataset.

    {4 Examples}

    {[
      delete_dataset dataset
      _ : (unit, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      delete_dataset dataset
      _ : (unit, [> `Internal_error of string ]) Lwt_result.t = Error _
    ]} *)

val search_datasets
  :  as_:Account.User.t
  -> Dataset.Query.t
  -> (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t
(** Search datasets matching the query.

    {4 Examples}

    {[
      search_datasets query
      _ : (Dataset.t list, [> `Internal_error of string ]) Lwt_result.t = Ok []
    ]} *)

val get_dataset_datapoints
  :  as_:Account.User.t
  -> ?limit:int
  -> ?offset:int
  -> ?split:Datapoint.Split.t
  -> Dataset.t
  -> ( Datapoint.t list
     , [> `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Get the dataset feature definition associated to the dataset. *)

val get_dataset_datapoint_count
  :  as_:Account_user.t
  -> Dataset_dataset.t
  -> (int, [> `Internal_error of string | `Permission_denied ]) result Lwt.t
(** Get the number of datapoints in the dataset. *)

val create_dataset_datapoint
  :  as_:Account.User.t
  -> features:Datapoint.feature list
  -> ?split:Datapoint.Split.t
  -> Dataset.t
  -> ( Datapoint.t
     , [> `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Create a new dataset datapoint. *)

val get_dataset_feature_definitions
  :  as_:Account.User.t
  -> Dataset.t
  -> ( Datapoint.definition list
     , [> `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Get the dataset datapoint associated to the dataset. *)

val create_dataset_feature_definition
  :  as_:Account.User.t
  -> name:Datapoint.Feature_name.t
  -> definition:Datapoint.definition_spec
  -> Dataset_dataset.t
  -> ( Datapoint.definition
     , [> `Already_exists | `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Create a new dataset feature definition. *)

val update_dataset_feature_definition
  :  as_:Account.User.t
  -> ?name:Datapoint.Feature_name.t
  -> ?definition:Datapoint.definition_spec
  -> Datapoint.definition
  -> ( Datapoint.definition
     , [> `Already_exists | `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** Update the dataset feature definition with [name]. *)

val delete_dataset_feature_definition
  :  as_:Account.User.t
  -> Datapoint.definition
  -> (unit, [> `Internal_error of string | `Permission_denied ]) Lwt_result.t
(** Delete the dataset feature definition. *)

val deliver_collaboration_instructions
  :  as_:Account.User.t
  -> url_fn:(string -> string)
  -> Account.User.t
  -> Dataset.t
  -> ( Account.User.Email.t * string
     , [> `Permission_denied | `Already_exists | `Internal_error of string ] )
     Lwt_result.t
(** ??? *)

val accept_collaboration_invitation
  :  as_:Account.User.t
  -> Token.t
  -> ( Dataset.t
     , [> `Internal_error of string | `Invalid_token | `Not_found ] )
     Lwt_result.t
(** ??? *)

val revoke_collaboration_invitation
  :  as_:Account.User.t
  -> Account.User.t
  -> Dataset.t
  -> ( unit
     , [> `Internal_error of string | `Not_found | `Permission_denied ] )
     Lwt_result.t
(** ??? *)

val get_pending_collaboration_invitations
  :  as_:Account.User.t
  -> Dataset.t
  -> ( Account_user.Email.t list
     , [> `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** ??? *)

val remove_collaborator
  :  as_:Account.User.t
  -> Account.User.t
  -> Dataset.t
  -> (unit, [> `Internal_error of string | `Permission_denied ]) result Lwt.t
(** ??? *)

val deliver_transfer_instructions
  :  as_:Account.User.t
  -> url_fn:(string -> string)
  -> Account.User.t
  -> Dataset.t
  -> ( Account.User.Email.t * string
     , [> `Internal_error of string | `Permission_denied | `Already_exists ] )
     Lwt_result.t
(** ??? *)

val accept_transfer_invitation
  :  as_:Account.User.t
  -> Token.t
  -> ( Dataset.t
     , [> `Internal_error of string | `Invalid_token | `Not_found ] )
     Lwt_result.t
(** ??? *)

val revoke_transfer_invitation
  :  as_:Account_user.t
  -> Dataset_dataset.t
  -> ( unit
     , [> `Internal_error of string | `Not_found | `Permission_denied ] )
     Lwt_result.t
(** ??? *)

val get_pending_transfer
  :  as_:Account.User.t
  -> Dataset.t
  -> ( Account_user.Email.t option
     , [> `Internal_error of string | `Permission_denied ] )
     Lwt_result.t
(** ??? *)
