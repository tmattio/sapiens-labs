open Sapiens_backend

let error = Alcotest.of_pp Model.Error.pp

let model = Alcotest.of_pp Model.Model.pp
