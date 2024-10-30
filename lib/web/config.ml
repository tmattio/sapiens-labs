module Env_production = struct
  let secret_key () = Sys.getenv "SAPIENS_SECRET_KEY"

  let session_cookie_salt = "28yeNDnW"

  let base_url = "http://localhost:3000"
end

module Env_development = struct
  let secret_key () =
    "6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe"

  let session_cookie_salt = "28yeNDnW"

  let base_url = "http://localhost:3000"
end

module Env_test = struct
  let secret_key () =
    "6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe"

  let session_cookie_salt = "28yeNDnW"

  let base_url = "http://localhost:3000"
end

module type ENV = sig
  val secret_key : unit -> string

  val session_cookie_salt : string

  val base_url : string
end

let is_test = Sapiens_backend.Config.is_test

let is_prod = Sapiens_backend.Config.is_prod

let is_dev = Sapiens_backend.Config.is_dev

let env =
  Sapiens_backend.Config.choose_env
    ~prod:(module Env_production : ENV)
    ~test:(module Env_test : ENV)
    ~dev:(module Env_development : ENV)

module Env = (val env)

let secret_key = Env.secret_key ()

let session_cookie_salt = Env.session_cookie_salt

let base_url = Env.base_url
