let setup_rnd_generators () = Mirage_crypto_rng_unix.initialize ()

let () =
  setup_rnd_generators ();
  Opium.App.run_command Sapiens_web.app
