open Sapiens_backend

let email_count = ref 0

let email_count_mutex = Mutex.create ()

let email_fixture ?v () =
  Mutex.lock email_count_mutex;
  let v =
    Account.User.Email.of_string
      (Option.value
         v
         ~default:("test" ^ string_of_int !email_count ^ "@example.com"))
    |> Result.get_ok
  in
  email_count := !email_count + 1;
  Mutex.unlock email_count_mutex;
  v

let username_count = ref 0

let username_count_mutex = Mutex.create ()

let username_fixture ?v () =
  Mutex.lock username_count_mutex;
  let v =
    Account.User.Username.of_string
      (Option.value v ~default:("username" ^ string_of_int !username_count))
    |> Result.get_ok
  in
  username_count := !username_count + 1;
  Mutex.unlock username_count_mutex;
  v

let password_fixture ?(v = "strongpassword") () =
  Account.User.Password.of_string v |> Result.get_ok

let user_fixture ?username:u_username ?password:u_password ?email:u_email () =
  let open Lwt.Syntax in
  let username = Option.value u_username ~default:(username_fixture ()) in
  let password = Option.value u_password ~default:(password_fixture ()) in
  let email = Option.value u_email ~default:(email_fixture ()) in
  let+ u = Sapiens_backend.Account.register_user ~username ~password ~email in
  Result.get_ok u
