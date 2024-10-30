open Sapiens_backend

let task_name_count = ref 0

let task_name_count_mutex = Mutex.create ()

let task_name_fixture ?v () =
  Mutex.lock task_name_count_mutex;
  let v =
    Annotation.Task.Name.of_string
      (Option.value v ~default:("model-name-" ^ string_of_int !task_name_count))
    |> Result.get_ok
  in
  task_name_count := !task_name_count + 1;
  Mutex.unlock task_name_count_mutex;
  v
