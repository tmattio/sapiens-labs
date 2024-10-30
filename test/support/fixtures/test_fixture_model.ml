open Sapiens_backend

let name_count = ref 0

let name_count_mutex = Mutex.create ()

let name_fixture ?v () =
  Mutex.lock name_count_mutex;
  let v =
    Model.Model.Name.of_string
      (Option.value v ~default:("model-name-" ^ string_of_int !name_count))
    |> Result.get_ok
  in
  name_count := !name_count + 1;
  Mutex.unlock name_count_mutex;
  v

let model_fixture ?user ?name () =
  let open Lwt.Syntax in
  let* user =
    match user with
    | Some user ->
      Lwt.return user
    | None ->
      Test_fixture_account.user_fixture ()
  in
  let name = Option.value name ~default:(name_fixture ()) in
  let+ d = Model.create_model ~user ~name () in
  Result.get_ok d
