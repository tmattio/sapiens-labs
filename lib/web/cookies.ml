open Opium

module User_token = struct
  let max_age = 60 * 60 * 24 * 60 |> Int64.of_int

  let key = "user_token"

  let signer = Cookie.Signer.make Config.secret_key

  let get req =
    Request.cookie ~signed_with:signer key req
    |> Option.map Sapiens_backend.Token.of_string

  let set t res =
    Response.add_cookie
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, Sapiens_backend.Token.to_string t)
      res

  let delete res = Response.remove_cookie key res

  let make t =
    Cookie.make
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, Sapiens_backend.Token.to_string t)
end

module Return_to = struct
  (* Valid for 5 minutes *)
  let max_age = 60 * 60 * 5 |> Int64.of_int

  let key = "return_to"

  let signer = Cookie.Signer.make Config.secret_key

  let get req = Request.cookie ~signed_with:signer key req

  let set t res =
    Response.add_cookie
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, t)
      res

  let delete res = Response.remove_cookie key res

  let make t =
    Cookie.make
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, t)
end

module Remember_me = struct
  (** Make the remember me cookie valid for 60 days.

      If you want to bump or reduce this value, also change the token expiry
      itself in [Account.User_token]. *)
  let max_age = 60 * 60 * 24 * 60 |> Int64.of_int

  let key = "user_remember_me"

  let signer = Cookie.Signer.make Config.secret_key

  let get req =
    Request.cookie ~signed_with:signer key req
    |> Option.map Sapiens_backend.Token.of_string

  let set token res =
    Response.add_cookie
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, Sapiens_backend.Token.to_string token)
      res

  let delete res = Response.remove_cookie key res

  let make token =
    Cookie.make
      ~expires:(`Max_age max_age)
      ~sign_with:signer
      ~same_site:`Strict
      ~http_only:true
      ~scope:(Uri.with_path Uri.empty "/")
      (key, Sapiens_backend.Token.to_string token)
end
