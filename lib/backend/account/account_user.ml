open Sexplib.Conv

module Username = struct
  open Std.Result.Syntax

  type t = string [@@deriving sexp, show, eq]

  let validate s =
    let is_character_ok c =
      (* '-' *)
      c = '-'
      (* Space *)
      || c = '_'
      (* Number *)
      || (c >= '0' && c <= '9')
      (* Capital letter *)
      || (c >= 'A' && c <= 'Z')
      (* Lowercase letter *)
      || (c >= 'a' && c <= 'z')
    in
    let is_string_valid str =
      let len = String.length str in
      let rec aux i j =
        if i >= len then
          true
        else if is_character_ok str.[i] then
          aux (succ i) (succ j)
        else
          false
      in
      aux 0 0
    in
    if String.length s > 60 then
      Error (`Validation_error "The name must contain at most 60 characters.")
    else if not (is_string_valid s) then
      Error
        (`Validation_error
          "The name must contain only alpha-numeric characters or special \
           characters '-' and '_'.")
    else
      Ok s

  let of_string s =
    let+ _result = validate s in
    s

  let to_string s = s

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok (to_string x))
        string)
end

module Email = struct
  open Std.Result.Syntax

  type t = string [@@deriving sexp, show, eq]

  let validate s =
    let* s =
      let regexp = Str.regexp "^.+@.+$" in
      if Str.string_match regexp s 0 then
        Ok s
      else
        Error (`Validation_error "The email is not valid")
    in
    if String.length s < 255 then
      Ok s
    else
      Error
        (`Validation_error "The email must contain at less than 255 characters")

  let of_string s =
    let+ _result = validate s in
    s

  let to_string s = s

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok (to_string x))
        string)
end

module Password = struct
  open Std.Result.Syntax

  type t = string [@@deriving eq]

  let validate s =
    if String.length s < 12 then
      Error
        (`Validation_error "The password must contain at least 12 characters")
    else if String.length s > 60 then
      Error
        (`Validation_error "The password must contain at most 60 characters")
    else
      Ok s

  let of_string s =
    let+ _result = validate s in
    s

  let to_string (s : t) : string = s

  let hash ?count plain =
    let plain = to_string plain in
    match count, Config.is_test with
    | _, true ->
      Bcrypt.hash ~count:4 plain |> Bcrypt.string_of_hash
    | Some count, false ->
      if count < 4 || count > 31 then
        failwith "Password hashing count has to be between 4 and 31"
      else
        Bcrypt.hash ~count plain |> Bcrypt.string_of_hash
    | None, false ->
      Bcrypt.hash ~count:10 plain |> Bcrypt.string_of_hash

  let verify ~hash ~plain =
    let hash = to_string hash in
    let plain = to_string plain in
    Bcrypt.verify plain (Bcrypt.hash_of_string hash)

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x ->
          of_string x
          |> Result.map_error (function `Validation_error err -> err))
        ~decode:(fun x -> Ok x)
        string)

  let pp ppf _t = Format.fprintf ppf "<hidden>"

  let show _t = "<hidden>"

  let sexp_of_t t = sexp_of_opaque t
end

module Ptime = struct
  include Ptime

  let sexp_of_t t = Format.asprintf "%a" pp t |> sexp_of_string
end

type t =
  { id : int
  ; hashed_password : Password.t
  ; username : Username.t
  ; email : Email.t
  ; confirmed_at : Ptime.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving sexp_of, show, eq, make]

let is_password_valid ~password user =
  Password.verify ~hash:user.hashed_password ~plain:password

let get_all () =
  let request =
    [%rapper
      get_many
        {sql|
        SELECT
          @int{id},
          @Username{username}, 
          @Password{hashed_password}, 
          @Email{email}, 
          @ptime?{confirmed_at}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM users
        |sql}
        record_out]
  in
  Repo.query (fun c -> request () c)

let get_by_id id =
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT
          @int{id},
          @Username{username}, 
          @Password{hashed_password}, 
          @Email{email}, 
          @ptime?{confirmed_at}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM users
        WHERE id = %int{id}
        |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~id)

let get_by_username username =
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT 
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        FROM users
        WHERE username = %Username{username}
        |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~username)

let get_by_email email =
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT 
          @int{id},
          @Username{username}, 
          @Password{hashed_password}, 
          @Email{email}, 
          @ptime?{confirmed_at}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM users
        WHERE email = %Email{email}
        |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~email)

let get_by_email_and_password ~email ~password =
  let open Lwt_result.Syntax in
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        FROM users
        WHERE email = %Email{email}
        |sql}
        record_out]
  in
  let* user = Repo.query_opt (fun c -> request c ~email) in
  if Password.verify ~hash:user.hashed_password ~plain:password then
    Ok user |> Lwt.return
  else
    Error `Not_found |> Lwt.return

let create ~username ~email ~password =
  let hashed_password = Password.hash password in
  let request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO users (username, email, hashed_password)
        VALUES (%Username{username}, %Email{email}, %Password{hashed_password})
        RETURNING
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~username ~email ~hashed_password)

let update ?username ?email ?password t =
  let username = Option.value username ~default:t.username in
  let email = Option.value email ~default:t.email in
  let hashed_password =
    password
    |> Option.map Password.hash
    |> Option.value ~default:t.hashed_password
  in
  let request =
    [%rapper
      get_one
        {sql|
        UPDATE users SET
          username = %Username{username},
          email = %Email{email}, 
          hashed_password = %Password{hashed_password}
        WHERE users.id = %int{id}
        RETURNING
          @int{id},
          @Username{username},
          @Password{hashed_password},
          @Email{email},
          @ptime?{confirmed_at},
          @ptime{created_at},
          @ptime{updated_at}
        |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~id:t.id ~username ~email ~hashed_password)

let delete t =
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM users
        WHERE users.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)
