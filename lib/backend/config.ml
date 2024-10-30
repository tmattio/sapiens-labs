let getenv e =
  try Sys.getenv e with
  | Not_found ->
    failwith
      (Printf.sprintf
         "The environment variable %s is required but is not set on your \
          system."
         e)

let getenv_opt = Sys.getenv_opt

type notifier =
  | Email
  | Console

module Env_production = struct
  let notifier = Email

  let database_uri () = getenv "DATABASE_URL"
end

module Env_development = struct
  let notifier = Console

  let database_uri () =
    let default =
      Printf.sprintf "postgresql://%s:%i/%s" "localhost" 5432 "sapiens_dev"
    in
    getenv_opt "DATABASE_URL" |> Option.value ~default
end

module Env_test = struct
  let notifier = Console

  let database_uri () =
    let default =
      Printf.sprintf "postgresql://%s:%i/%s" "localhost" 5432 "sapiens_test"
    in
    getenv_opt "DATABASE_URL" |> Option.value ~default
end

module type ENV = sig
  val notifier : notifier

  val database_uri : unit -> string
end

let is_test =
  match Sys.getenv_opt "SAPIENS_ENV" with Some "test" -> true | _ -> false

let is_prod =
  match Sys.getenv_opt "SAPIENS_ENV" with
  | Some "prod" | Some "production" ->
    true
  | _ ->
    false

let is_dev = (not is_test) && not is_prod

let choose_env ~prod ~dev ~test =
  match Sys.getenv_opt "SAPIENS_ENV" with
  | Some "prod" | Some "production" ->
    prod
  | Some "dev" | Some "development" ->
    dev
  | Some "test" ->
    test
  | _ ->
    dev

let env =
  choose_env
    ~prod:(module Env_production : ENV)
    ~test:(module Env_test : ENV)
    ~dev:(module Env_development : ENV)

module Env = (val env)

let database_uri = Env.database_uri ()

let notifier = Env.notifier

let mailgun_api_key =
  match notifier with
  | Email ->
    getenv "SAPIENS_MAILGUN_API_KEY"
  | Console ->
    (* The API key should not be used when the notifier is Console *)
    ""
