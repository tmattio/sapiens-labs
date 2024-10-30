module Query = struct
  type t = string [@@deriving show, eq]

  let clean_search_query q =
    let is_character_ok c =
      (* Space *)
      c = ' '
      (* '-' *)
      || c = '-'
      (* Space *)
      || c = '_'
      (* Number *)
      || (c >= '0' && c <= '9')
      (* Capital letter *)
      || (c >= 'A' && c <= 'Z')
      (* Lowercase letter *)
      || (c >= 'a' && c <= 'z')
    in
    let strip str =
      let len = String.length str in
      let res = Bytes.create len in
      let rec aux i j =
        if i >= len then
          Bytes.to_string (Bytes.sub res 0 j)
        else if is_character_ok str.[i] then (
          Bytes.set res j str.[i];
          aux (succ i) (succ j))
        else
          aux (succ i) j
      in
      aux 0 0
    in
    strip q

  let of_string s = clean_search_query s

  let to_string s = s

  let t =
    Caqti_type.(
      custom
        ~encode:(fun x -> Ok (of_string x))
        ~decode:(fun x -> Ok (to_string x))
        string)
end

module Name = struct
  open Std.Result.Syntax

  type t = string [@@deriving show, eq]

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

module Description = struct
  open Std.Result.Syntax

  type t = string [@@deriving show, eq]

  let validate s =
    if String.length s <= 120 then
      Ok s
    else
      Error
        (`Validation_error
          "The description must contain at most 120 characters")

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

type t =
  { id : int
  ; name : Name.t
  ; description : Description.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving show, eq]

let get_all () =
  let request =
    [%rapper
      get_many
        {sql|
        SELECT
          @int{id},
          @Name{name}, 
          @Description?{description}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM models
        |sql}
        record_out]
  in
  Repo.query (fun c -> request () c)

let get_by_user user =
  let request =
    [%rapper
      get_many
        {sql|
          SELECT
            @int{id},
            @Name{name}, 
            @Description?{description}, 
            @ptime{created_at}, 
            @ptime{updated_at}
          FROM models
          WHERE user_id = %int{user_id}
          |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~user_id:user.Account.User.id)

let get_by_id id =
  let request =
    [%rapper
      get_opt
        {sql|
        SELECT
          @int{id},
          @Name{name}, 
          @Description?{description}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM models
        WHERE id = %int{id}
        |sql}
        record_out]
  in
  Repo.query_opt (fun c -> request c ~id)

let create ~user ~name ?description () =
  let user_id = user.Account.User.id in
  let request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO models (name, description, user_id)
        VALUES (%Name{name}, %Description?{description}, %int{user_id})
        RETURNING
          @int{id},
          @Name{name}, 
          @Description?{description}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~name ~description ~user_id)

let update ?name ?description t =
  let name = Option.value name ~default:t.name in
  let description =
    match description with None -> t.description | Some t -> Some t
  in
  let request =
    [%rapper
      get_one
        {sql|
        UPDATE models SET name = %Name{name}, description = %Description?{description}
        WHERE models.id = %int{id}
        RETURNING
          @int{id},
          @Name{name}, 
          @Description?{description}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~id:t.id ~name ~description)

let delete t =
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM models
        WHERE models.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)

let search q =
  let request =
    [%rapper
      get_many
        {sql|
        SELECT
          @int{id},
          @Name{name}, 
          @Description?{description}, 
          @ptime{created_at}, 
          @ptime{updated_at}
        FROM models
        WHERE 
          models.name ILIKE '%' || %Query{q} || '%' OR
          models.description ILIKE '%' || %Query{q} || '%'
        |sql}
        record_out]
  in
  Repo.query (fun c -> request c ~q)
