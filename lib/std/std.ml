include StdLabels

module Option = struct
  include Option

  module Infix = struct
    let ( >>| ) t f = map f t

    let ( >>= ) t f = bind t f
  end

  module Syntax = struct
    open Infix

    let ( let+ ) = ( >>| )

    let ( let* ) = ( >>= )

    let ( and+ ) a b =
      a >>= fun a ->
      b >>| fun b -> a, b
  end
end

module Result = struct
  include Result

  module Infix = struct
    let ( >>| ) t f = map f t

    let ( >>= ) t f = bind t f
  end

  module Syntax = struct
    open Infix

    let ( let+ ) = ( >>| )

    let ( let* ) = ( >>= )

    let ( and+ ) a b =
      a >>= fun a ->
      b >>| fun b -> a, b
  end
end

module String = struct
  include String

  let is_prefix = Astring.String.is_prefix

  let is_suffix = Astring.String.is_suffix

  let cut = Astring.String.cut

  let filter = Astring.String.filter

  let drop = Astring.String.drop

  let cuts = Astring.String.cuts

  let find = Astring.String.find

  let find_sub = Astring.String.find_sub

  let contains_s ~sub s = find_sub ~sub s |> Option.is_some
end
