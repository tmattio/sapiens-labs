module Config = struct
  let hash_algorithm = `SHA256

  let rand_size = 32
end

type t = Cstruct.t

let of_string s = Cstruct.of_string s

let to_string t = Cstruct.to_string t

let pp ppf t = Cstruct.hexdump_pp ppf t

let show = to_string

let equal = Cstruct.equal

let generate () = Mirage_crypto_rng.generate Config.rand_size

let hash t = Mirage_crypto.Hash.digest Config.hash_algorithm t

let encode_base64 t =
  t
  |> to_string
  |> Base64.encode ~alphabet:Base64.uri_safe_alphabet ~pad:false
  |> Result.map_error (function `Msg err -> `Internal_error err)
  |> Result.map (fun x -> of_string x)

let decode_base64 t =
  t
  |> to_string
  |> Base64.decode ~alphabet:Base64.uri_safe_alphabet ~pad:false
  |> Result.map_error (function `Msg err -> `Internal_error err)
  |> Result.map (fun x -> of_string x)

let t =
  Caqti_type.(
    custom
      ~encode:(fun x -> Ok (to_string x))
      ~decode:(fun x -> Ok (of_string x))
      octets)
