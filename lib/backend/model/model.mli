(** The Model context. *)

module Error : sig
  type t = [ | Error.t ] [@@deriving show, eq]
end

module Model = Model_model

val list_user_models
  :  Account.User.t
  -> (Model.t list, [> `Internal_error of string ]) Lwt_result.t
(** Returns the list of models of the user.

    {4 Examples}

    {[
      list_user_models ()
      _ : (Model.t list, [> `Internal_error of string ]) Lwt_result.t = Ok []
    ]} *)

val get_model_by_id
  :  int
  -> (Model.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t
(** Gets a single model.

    {4 Examples}

    {[
      get_model_by_id 123
      _ : (Model.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Ok { id = 123 ; _ }

      get_model_by_id 456
      _ : (Model.t, [> `Internal_error of string | `Not_found ]) Lwt_result.t = Error "No results"
    ]} *)

val create_model
  :  user:Account.User.t
  -> name:Model.Name.t
  -> ?description:Model.Description.t
  -> unit
  -> (Model.t, [> `Already_exists | `Internal_error of string ]) Lwt_result.t
(** Gets a single model.

    {4 Examples}

    {[
      create_model ~name:"valid"
      _ : (Model.t, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      create_model ~name:"invalid"
      _ : (Model.t, [> `Internal_error of string ]) Lwt_result.t = Error "invalid name"
    ]} *)

val update_model
  :  ?name:Model.Name.t
  -> ?description:Model.Description.t
  -> Model.t
  -> (Model.t, [> `Internal_error of string ]) Lwt_result.t
(** Updates a model.

    {4 Examples}

    {[
      update_model ~name:"valid" model
      _ : (Model.t, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      update_model ~name:"invalid" model
      _ : (Model.t, [> `Internal_error of string ]) Lwt_result.t = Error "invalid name"
    ]} *)

val delete_model
  :  Model.t
  -> (unit, [> `Internal_error of string ]) Lwt_result.t
(** Deletes a model.

    {4 Examples}

    {[
      delete_model model
      _ : (unit, [> `Internal_error of string ]) Lwt_result.t = Ok { id = 123 ; _ }

      delete_model model
      _ : (unit, [> `Internal_error of string ]) Lwt_result.t = Error _
    ]} *)

val search_models
  :  Model.Query.t
  -> (Model.t list, [> `Internal_error of string ]) Lwt_result.t
(** Search models matching the query.

    {4 Examples}

    {[
      search_models query
      _ : (Model.t list, [> `Internal_error of string ]) Lwt_result.t = Ok []
    ]} *)
