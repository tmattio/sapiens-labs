open Sapiens_backend

let error = Alcotest.of_pp Account.Error.pp

let user = Alcotest.of_pp Account.User.pp

let user_token = Alcotest.of_pp Account.User_token.pp

let token = Alcotest.of_pp Token.pp

let context = Alcotest.of_pp Account.User_token.Context.pp

let username = Alcotest.of_pp Account.User.Username.pp

let email = Alcotest.of_pp Account.User.Email.pp

let password = Alcotest.of_pp Account.User.Password.pp

let ptime = Alcotest.of_pp (fun ppf t -> Ptime.pp_rfc3339 () ppf t)
