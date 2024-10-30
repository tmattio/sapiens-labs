(lang dune 2.0)

(name sapiens)

(source
 (github tmattio/sapiens))

(license MIT)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(package
 (name sapiens)
 (synopsis "Fullstack application for Sapiens")
 (description "Fullstack application for Sapiens.")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  ;; Embedding static files
  (crunch :build)
  ;; General
  astring
  sexplib0
  lwt
  streaming
  ;; Web server
  uri
  opium
  ;; Javascript
  js_of_ocaml
  brr
  lwd
  tyxml-lwd
  ;; PPX
  ppx_sexp_conv
  ppx_deriving
  ppx_deriving_yojson
  ;; Encryption
  safepass
  mirage-crypto-rng
  cstruct
  ;; HTTP client
  cohttp-lwt-unix
  ;; Database
  ppx_rapper
  caqti
  caqti-lwt
  caqti-driver-postgresql
  ;; Test
  (alcotest :with-test)
  (alcotest-lwt :with-test)
  (opium-testing :with-test)
  ;; Documentation
  (odoc :with-doc)))
