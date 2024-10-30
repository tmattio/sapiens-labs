module Model = Model_model

module Error = struct
  type t = [ | Error.t ] [@@deriving show, eq]
end

let list_user_models user = Model.get_by_user user

let get_model_by_id id = Model.get_by_id id

let create_model ~user ~name ?description () =
  let open Lwt_result.Syntax in
  let open Model in
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT @int{id}
        FROM models
        WHERE name = %Name{name} AND user_id = %int{user_id}
        |sql}]
  in
  let* id_opt =
    Repo.query (fun c -> request c ~name ~user_id:user.Account.User.id)
  in
  match id_opt with
  | Some _ ->
    Lwt.return (Error `Already_exists)
  | None ->
    Model.create ~user ~name ?description ()

let update_model ?name ?description model =
  Model.update ?name ?description model

let delete_model model = Model.delete model

let search_models query = Model.search query
