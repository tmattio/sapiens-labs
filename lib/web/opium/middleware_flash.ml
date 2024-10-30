let m () =
  (* TODO: Implement flash middleware *)
  let filter handler req = handler req in
  Rock.Middleware.create ~name:"Flash" ~filter
