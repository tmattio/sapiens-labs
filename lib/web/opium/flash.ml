open Opium
open Sexplib.Conv

module Flash_cookie = struct
  (* Valid for 5 minutes *)
  let max_age = 60 * 60 * 5 |> Int64.of_int

  let key = "flash"

  let get req = Request.cookie key req

  let set t res =
    Response.add_cookie
      ~expires:(`Max_age max_age)
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, t)
      res

  let delete res = Response.remove_cookie key res

  let make t =
    Cookie.make
      ~expires:(`Max_age max_age)
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, t)
end

type message =
  [ `error of string
  | `warning of string
  | `success of string
  | `info of string
  ]
[@@deriving sexp]

let get_message req =
  Flash_cookie.get req
  |> Option.map Sexplib.Sexp.of_string
  |> Option.map message_of_sexp

let set_message message res =
  let message = message |> sexp_of_message |> Sexplib.Sexp.to_string in
  Flash_cookie.set message res

let set_info txt res = set_message (`info txt) res

let set_warning txt res = set_message (`warning txt) res

let set_success txt res = set_message (`success txt) res

let set_error txt res = set_message (`error txt) res
