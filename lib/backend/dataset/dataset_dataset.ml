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

module Name = Helper.Make_field (struct
  type t = string [@@deriving show, eq]

  let caqti_type = Caqti_type.string

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
    let open Std.Result.Syntax in
    let* _ = Helper.validate_string_length ~name:"name" ~max:60 s in
    if not (is_string_valid s) then
      Error
        (`Validation_error
          "The name must contain only alpha-numeric characters or special \
           characters '-' and '_'.")
    else
      Ok s
end)

module Description = Helper.Make_field (struct
  type t = string [@@deriving show, eq]

  let caqti_type = Caqti_type.string

  let validate =
    Helper.validate_string_length ~name:"description" ~max:1000 ~min:1
end)

module Homepage = Helper.Make_field (struct
  type t = string [@@deriving show, eq]

  let caqti_type = Caqti_type.string

  let validate = Helper.validate_string_length ~name:"homepage" ~max:2000 ~min:1
end)

module Citation = Helper.Make_field (struct
  type t = string [@@deriving show, eq]

  let caqti_type = Caqti_type.string

  let validate = Helper.validate_string_length ~name:"citation" ~max:2000 ~min:1
end)

type db_record =
  { id : int
  ; name : Name.t
  ; is_public : bool
  ; description : Description.t option
  ; homepage : Homepage.t option
  ; citation : Citation.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving make]

type t =
  { id : int
  ; user : Account.User.t
  ; collaborators : Account.User.t list
  ; name : Name.t
  ; is_public : bool
  ; description : Description.t option
  ; homepage : Homepage.t option
  ; citation : Citation.t option
  ; created_at : Ptime.t
  ; updated_at : Ptime.t
  }
[@@deriving show, eq, make]

let user_of_rapper
    ~id ~username ~hashed_password ~email ~confirmed_at ~created_at ~updated_at
  =
  Account_user.make
    ~id
    ~username
    ~hashed_password
    ~email
    ?confirmed_at
    ~created_at
    ~updated_at
    ()

let opt_user_of_rapper
    ~id ~username ~hashed_password ~email ~confirmed_at ~created_at ~updated_at
  =
  match id with
  | Some id ->
    Some
      (Account_user.make
         ~id
         ~username:(Option.get username)
         ~hashed_password:(Option.get hashed_password)
         ~email:(Option.get email)
         ?confirmed_at
         ~created_at:(Option.get created_at)
         ~updated_at:(Option.get updated_at)
         ())
  | None ->
    None

let db_record_of_rapper
    ~id
    ~name
    ~is_public
    ~description
    ~homepage
    ~citation
    ~created_at
    ~updated_at
  =
  make_db_record
    ~id
    ~name
    ~is_public
    ?description
    ?homepage
    ?citation
    ~created_at
    ~updated_at
    ()

let get_many f =
  let open Lwt_result.Syntax in
  let* db_record = Repo.query f in
  let db_record_with_user =
    ListLabels.map
      db_record
      ~f:(fun ((dataset : db_record), user, collaborator) ->
        ( { id = dataset.id
          ; user
          ; collaborators = []
          ; name = dataset.name
          ; is_public = dataset.is_public
          ; description = dataset.description
          ; homepage = dataset.homepage
          ; citation = dataset.citation
          ; created_at = dataset.created_at
          ; updated_at = dataset.updated_at
          }
        , collaborator ))
  in
  let* datasets =
    try
      Lwt_result.return
      @@ Rapper.load_many
           ((fun (x, _) -> x), fun ({ id; _ } : t) -> id)
           [ ( (fun (_, x) -> x)
             , fun (dataset : t) collaborators ->
                 let collaborators =
                   List.fold_left
                     (fun acc -> function Some el -> el :: acc | None -> acc)
                     []
                     collaborators
                 in
                 { dataset with collaborators } )
           ]
           db_record_with_user
    with
    | Failure s ->
      Lwt.return_error (`Internal_error s)
  in
  Lwt_result.return datasets

let get_all () =
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{datasets.id},
          @Name{datasets.name},
          @bool{datasets.is_public},
          @Description?{datasets.description},
          @Homepage?{datasets.homepage},
          @Citation?{datasets.citation},
          @ptime{datasets.created_at}, 
          @ptime{datasets.updated_at},
          @int{users.id},
          @Username{users.username}, 
          @Password{users.hashed_password}, 
          @Email{users.email}, 
          @ptime?{users.confirmed_at}, 
          @ptime{users.created_at}, 
          @ptime{users.updated_at},
          @int?{collaborators.id},
          @Username?{collaborators.username}, 
          @Password?{collaborators.hashed_password}, 
          @Email?{collaborators.email}, 
          @ptime?{collaborators.confirmed_at}, 
          @ptime?{collaborators.created_at}, 
          @ptime?{collaborators.updated_at}
        FROM datasets
        LEFT JOIN users ON users.id = datasets.user_id
        LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
        LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
        ORDER BY datasets.id ASC
        |sql}
        function_out]
  in
  get_many (fun c ->
      request (db_record_of_rapper, user_of_rapper, opt_user_of_rapper) () c)

let get_by_user user =
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
          SELECT
            @int{datasets.id},
            @Name{datasets.name},
            @bool{datasets.is_public},
            @Description?{datasets.description},
            @Homepage?{datasets.homepage},
            @Citation?{datasets.citation},
            @ptime{datasets.created_at}, 
            @ptime{datasets.updated_at},
            @int{users.id},
            @Username{users.username}, 
            @Password{users.hashed_password}, 
            @Email{users.email}, 
            @ptime?{users.confirmed_at}, 
            @ptime{users.created_at}, 
            @ptime{users.updated_at},
            @int?{collaborators.id},
            @Username?{collaborators.username}, 
            @Password?{collaborators.hashed_password}, 
            @Email?{collaborators.email}, 
            @ptime?{collaborators.confirmed_at}, 
            @ptime?{collaborators.created_at}, 
            @ptime?{collaborators.updated_at}
          FROM datasets
          LEFT JOIN users ON users.id = datasets.user_id
          LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
          LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
          WHERE datasets.user_id = %int{user_id}
          ORDER BY datasets.id ASC
          |sql}
        function_out]
  in
  get_many (fun c ->
      request
        (db_record_of_rapper, user_of_rapper, opt_user_of_rapper)
        c
        ~user_id:user.Account.User.id)

let get_shared_by_user user =
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{datasets.id},
          @Name{datasets.name},
          @bool{datasets.is_public},
          @Description?{datasets.description},
          @Homepage?{datasets.homepage},
          @Citation?{datasets.citation},
          @ptime{datasets.created_at}, 
          @ptime{datasets.updated_at},
          @int{users.id},
          @Username{users.username}, 
          @Password{users.hashed_password}, 
          @Email{users.email}, 
          @ptime?{users.confirmed_at}, 
          @ptime{users.created_at}, 
          @ptime{users.updated_at},
          @int?{collaborators.id},
          @Username?{collaborators.username}, 
          @Password?{collaborators.hashed_password}, 
          @Email?{collaborators.email}, 
          @ptime?{collaborators.confirmed_at}, 
          @ptime?{collaborators.created_at}, 
          @ptime?{collaborators.updated_at}
        FROM datasets
        LEFT JOIN users ON users.id = datasets.user_id
        LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
        LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
        WHERE datasets.user_id = %int{user_id} OR dataset_collaborators.user_id = %int{user_id}
        ORDER BY datasets.id ASC
        |sql}
        function_out]
  in
  get_many (fun c ->
      request
        (db_record_of_rapper, user_of_rapper, opt_user_of_rapper)
        c
        ~user_id:user.Account.User.id)

let get_by_name_and_username ~name ~username =
  let open Lwt_result.Syntax in
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{datasets.id},
          @Name{datasets.name},
          @bool{datasets.is_public},
          @Description?{datasets.description},
          @Homepage?{datasets.homepage},
          @Citation?{datasets.citation},
          @ptime{datasets.created_at}, 
          @ptime{datasets.updated_at},
          @int{users.id},
          @Username{users.username}, 
          @Password{users.hashed_password}, 
          @Email{users.email}, 
          @ptime?{users.confirmed_at}, 
          @ptime{users.created_at}, 
          @ptime{users.updated_at},
          @int?{collaborators.id},
          @Username?{collaborators.username}, 
          @Password?{collaborators.hashed_password}, 
          @Email?{collaborators.email}, 
          @ptime?{collaborators.confirmed_at}, 
          @ptime?{collaborators.created_at}, 
          @ptime?{collaborators.updated_at}
        FROM datasets
        LEFT JOIN users ON users.id = datasets.user_id
        LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
        LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
        WHERE users.username = %Username{username} AND datasets.name = %Name{name}
        ORDER BY datasets.id ASC
        |sql}
        function_out]
  in
  let* datasets =
    get_many (fun c ->
        request
          (db_record_of_rapper, user_of_rapper, opt_user_of_rapper)
          c
          ~name
          ~username)
  in
  match datasets with
  | [] ->
    Lwt.return_error `Not_found
  | [ el ] ->
    Lwt.return_ok el
  | _ ->
    Lwt.return_error
      (`Internal_error "Got multiple datasets, only one was expected")

let get_by_id id =
  let open Lwt_result.Syntax in
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{datasets.id},
          @Name{datasets.name},
          @bool{datasets.is_public},
          @Description?{datasets.description},
          @Homepage?{datasets.homepage},
          @Citation?{datasets.citation},
          @ptime{datasets.created_at}, 
          @ptime{datasets.updated_at},
          @int{users.id},
          @Username{users.username}, 
          @Password{users.hashed_password}, 
          @Email{users.email}, 
          @ptime?{users.confirmed_at}, 
          @ptime{users.created_at}, 
          @ptime{users.updated_at},
          @int?{collaborators.id},
          @Username?{collaborators.username}, 
          @Password?{collaborators.hashed_password}, 
          @Email?{collaborators.email}, 
          @ptime?{collaborators.confirmed_at}, 
          @ptime?{collaborators.created_at}, 
          @ptime?{collaborators.updated_at}
        FROM datasets
        LEFT JOIN users ON users.id = datasets.user_id
        LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
        LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
        WHERE datasets.id = %int{id}
        ORDER BY datasets.id ASC
        |sql}
        function_out]
  in
  let* datasets =
    get_many (fun c ->
        request (db_record_of_rapper, user_of_rapper, opt_user_of_rapper) ~id c)
  in
  match datasets with
  | [] ->
    Lwt.return_error `Not_found
  | [ el ] ->
    Lwt.return_ok el
  | _ ->
    Lwt.return_error
      (`Internal_error "Got multiple datasets, only one was expected")

let create ~user ~name ?description ?homepage ?citation ?(is_public = false) () =
  let open Lwt_result.Syntax in
  let user_id = user.Account.User.id in
  let request =
    [%rapper
      get_one
        {sql| 
        INSERT INTO datasets (name, description, homepage, citation, user_id, is_public)
        VALUES (%Name{name}, %Description?{description}, %Homepage?{homepage}, %Citation?{citation}, %int{user_id}, %bool{is_public})
        RETURNING @int{id}
        |sql}]
  in
  let* id =
    Repo.query (fun c ->
        request c ~name ~description ~homepage ~citation ~user_id ~is_public)
  in
  Lwt_result.map_err
    (function
      | `Not_found ->
        `Internal_error "The dataset could not be found after create"
      | `Internal_error _ as err ->
        err)
    (get_by_id id)

let update ?name ?description ?homepage ?citation ?is_public (t : t) =
  let open Lwt_result.Syntax in
  let name = Option.value name ~default:t.name in
  let description =
    match description with None -> t.description | Some t -> Some t
  in
  let homepage = match homepage with None -> t.homepage | Some t -> Some t in
  let citation = match citation with None -> t.citation | Some t -> Some t in
  let is_public = match is_public with None -> t.is_public | Some t -> t in
  let request =
    [%rapper
      get_one
        {sql|
        UPDATE datasets SET name = %Name{name}, description = %Description?{description}, homepage = %Homepage?{homepage}, citation = %Citation?{citation}, is_public = %bool{is_public}
        WHERE datasets.id = %int{id}
        RETURNING
          @int{id}
        |sql}]
  in
  let* id =
    Repo.query (fun c ->
        request c ~id:t.id ~name ~description ~homepage ~citation ~is_public)
  in
  Lwt_result.map_err
    (function
      | `Not_found ->
        `Internal_error "The dataset could not be found after update"
      | `Internal_error _ as err ->
        err)
    (get_by_id id)

let update_owner user (t : t) =
  let open Lwt_result.Syntax in
  let user_id = user.Account.User.id in
  let request =
    [%rapper
      get_one
        {sql|
        UPDATE datasets SET user_id = %int{user_id}
        WHERE datasets.id = %int{id}
        RETURNING
          @int{id}
        |sql}]
  in
  let* id = Repo.query (fun c -> request c ~id:t.id ~user_id) in
  Lwt_result.map_err
    (function
      | `Not_found ->
        `Internal_error "The dataset could not be found after update"
      | `Internal_error _ as err ->
        err)
    (get_by_id id)

let delete (t : t) =
  let request =
    [%rapper
      execute
        {sql|
        DELETE FROM datasets
        WHERE datasets.id = %int{id}
        |sql}]
  in
  Repo.query (fun c -> request c ~id:t.id)

let search q =
  let request =
    let open Account_user in
    [%rapper
      get_many
        {sql|
        SELECT
          @int{datasets.id},
          @Name{datasets.name},
          @bool{datasets.is_public},
          @Description?{datasets.description},
          @Homepage?{datasets.homepage},
          @Citation?{datasets.citation},
          @ptime{datasets.created_at}, 
          @ptime{datasets.updated_at},
          @int{users.id},
          @Username{users.username}, 
          @Password{users.hashed_password}, 
          @Email{users.email}, 
          @ptime?{users.confirmed_at}, 
          @ptime{users.created_at}, 
          @ptime{users.updated_at},
          @int?{collaborators.id},
          @Username?{collaborators.username}, 
          @Password?{collaborators.hashed_password}, 
          @Email?{collaborators.email}, 
          @ptime?{collaborators.confirmed_at}, 
          @ptime?{collaborators.created_at}, 
          @ptime?{collaborators.updated_at}
        FROM datasets
        LEFT JOIN users ON users.id = datasets.user_id
        LEFT JOIN dataset_collaborators ON dataset_collaborators.dataset_id = datasets.id
        LEFT JOIN users as collaborators ON dataset_collaborators.user_id = collaborators.id
        WHERE 
          datasets.name ILIKE '%' || %Query{q} || '%' OR
          datasets.description ILIKE '%' || %Query{q} || '%'
        ORDER BY datasets.id ASC
        |sql}
        function_out]
  in
  get_many (fun c ->
      request (db_record_of_rapper, user_of_rapper, opt_user_of_rapper) c ~q)
