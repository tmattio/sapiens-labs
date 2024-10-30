open Sapiens_backend

let error = Alcotest.of_pp Dataset.Error.pp

let dataset = Alcotest.of_pp Dataset.Dataset.pp

let datapoint = Alcotest.of_pp Dataset.Datapoint.pp

let feature_name = Alcotest.of_pp Dataset.Datapoint.Feature_name.pp

let definition = Alcotest.of_pp Dataset.Datapoint.pp_definition

let feature = Alcotest.of_pp Dataset.Datapoint.pp_feature

let dataset_token = Alcotest.of_pp Dataset.Dataset_token.pp

let context = Alcotest.of_pp Dataset.Dataset_token.Context.pp
