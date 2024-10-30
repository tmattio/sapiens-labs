(** Configuration of the application.

    The configurations values depend on the application environment defined by
    the environment variable [SAPIENS_ENV]. *)
module Config : sig
  type notifier =
    | Email
    | Console

  val is_test : bool
  (** Whether the application is running in test environment.

      The application runs in a test environment when the environment variable
      [SAPIENS_ENV] is set to [test] (e.g. [export SAPIENS_ENV=test]) *)

  val is_prod : bool
  (** Whether the application is running in production environment.

      The application runs in a production environment when the environment
      variable [SAPIENS_ENV] is set to [production] (e.g.
      [export SAPIENS_ENV=production]) *)

  val is_dev : bool
  (** Whether the application is running in development environment.

      The application runs in a development environment when the environment
      variable [SAPIENS_ENV] is set to [production] (e.g.
      [export SAPIENS_ENV=production]) or when the environment variable
      [SAPIENS_ENV] is undefined. *)

  val choose_env : prod:'a -> dev:'a -> test:'a -> 'a
  (** Choose an environment depending on the value of the environment variable
      [SAPIENS_ENV]. *)

  val database_uri : string
  (** The full URI of the database.

      [database_uri] is built from the values of [database_host],
      [database_port] and [database_name]. *)

  val mailgun_api_key : string

  val notifier : notifier
end =
  Config

module Repo = Repo

(** General error definition and handling. *)
module Error = Error

(** A standard library superset. *)
module Std = Std

module Account = Account
module Dataset = Dataset
module Annotation = Annotation
module Model = Model
module Upload = Upload
module Token = Token
