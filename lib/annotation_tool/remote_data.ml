type ('a, 'b) t =
  | Loaded of 'a
  | Error of 'b
  | Not_asked
  | Loading
