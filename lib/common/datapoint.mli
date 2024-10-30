module Feature_type : sig
  type t =
    | Image
    | Text
    | Bbox
    | Label
    | Number
    | Tokens
    | Entity
    | Sequence of t

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  type sequence = t list

  val sequence_to_yojson : sequence -> Yojson.Safe.t

  val sequence_of_yojson
    :  Yojson.Safe.t
    -> sequence Ppx_deriving_yojson_runtime.error_or
end

module Feature_name : sig
  type t = string

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> t

  val validate : t -> (t, [> `Validation_error of t ]) result

  val of_string : t -> (t, [> `Validation_error of t ]) result

  val to_string : 'a -> 'a
end

module Split : sig
  type t = string

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> t

  val validate : t -> (t, [> `Validation_error of t ]) result

  val of_string : t -> (t, [> `Validation_error of t ]) result

  val to_string : 'a -> 'a
end

type 'a persisted_definition =
  { id : int
  ; dataset_id : int
  ; feature_name : string
  ; spec : 'a
  }

val persisted_definition_to_yojson
  :  ('a -> Yojson.Safe.t)
  -> 'a persisted_definition
  -> Yojson.Safe.t

val persisted_definition_of_yojson
  :  (Yojson.Safe.t -> 'a Ppx_deriving_yojson_runtime.error_or)
  -> Yojson.Safe.t
  -> 'a persisted_definition Ppx_deriving_yojson_runtime.error_or

val pp_persisted_definition
  :  (Format.formatter -> 'a -> unit)
  -> Format.formatter
  -> 'a persisted_definition
  -> unit

val show_persisted_definition
  :  (Format.formatter -> 'a -> unit)
  -> 'a persisted_definition
  -> string

module Image : sig
  module Definition : sig
    type t =
      { height : int option
      ; width : int option
      ; channels : int
      }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val height : t -> int option

    val width : t -> int option

    val channels : t -> int

    val make : ?height:int -> ?width:int -> ?channels:int -> unit -> t
  end

  module Feature : sig
    type t =
      { url : string
      ; height : int
      ; width : int
      ; channels : int
      }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val make : url:string -> height:int -> width:int -> channels:int -> t

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val url : t -> string

    val height : t -> int

    val width : t -> int

    val channels : t -> int
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val url : t -> string

  val height : t -> int

  val width : t -> int

  val channels : t -> int

  val validate
    :  definition:Definition.t
    -> t
    -> (t, [> `Validation_error of string ]) result

  val make
    :  definition:Definition.t persisted_definition
    -> url:string
    -> height:int
    -> width:int
    -> channels:int
    -> (t, [> `Validation_error of string ]) result
end

module Text : sig
  module Definition : sig
    type t = unit

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> t

    val show : t -> string

    val make : t -> t
  end

  module Feature : sig
    type t = { text : string }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val value : t -> string

    val make : string -> t
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val value : t -> string

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> string
    -> (t, 'a) result
end

module Bbox : sig
  module Definition : sig
    type t

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> t

    val show : t -> string

    val make : unit -> t
  end

  module Feature : sig
    type t =
      { y_min : float
      ; x_min : float
      ; y_max : float
      ; x_max : float
      }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val make : y_min:float -> x_min:float -> y_max:float -> x_max:float -> t

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val y_min : t -> float

    val x_min : t -> float

    val y_max : t -> float

    val x_max : t -> float
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val y_min : t -> float

  val x_min : t -> float

  val y_max : t -> float

  val x_max : t -> float

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> y_min:float
    -> x_min:float
    -> y_max:float
    -> x_max:float
    -> (t, 'a) result
end

module Label : sig
  module Definition : sig
    type t = { classes : string list }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val classes : t -> string list

    val make : classes:string list -> t
  end

  module Feature : sig
    type t = { label : string }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val value : t -> string

    val make : string -> t
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val value : t -> string

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> string
    -> (t, 'a) result
end

module Number : sig
  module Definition : sig
    type t =
      { min : float option
      ; max : float option
      }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val min : t -> float option

    val max : t -> float option

    val make : ?min:float -> ?max:float -> unit -> t
  end

  module Feature : sig
    type t = { value : float }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val value : t -> float

    val make : float -> t
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val value : t -> float

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> float
    -> (t, 'a) result
end

module Tokens : sig
  type token =
    { text : string
    ; start : int
    ; end_ : int
    }

  val token_to_yojson : token -> Yojson.Safe.t

  val token_of_yojson
    :  Yojson.Safe.t
    -> token Ppx_deriving_yojson_runtime.error_or

  val pp_token : Format.formatter -> token -> unit

  val show_token : token -> string

  module Definition : sig
    type t = unit

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> t

    val show : t -> string

    val make : t -> t
  end

  module Feature : sig
    type t = token list

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val tokens : 'a -> 'a

    val make : 'a -> 'a
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val tokens : t -> Feature.t

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> Feature.t
    -> (t, 'a) result
end

module Entity : sig
  module Definition : sig
    type t = { classes : string list }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val classes : t -> string list

    val make : classes:string list -> t
  end

  module Feature : sig
    type t =
      { start : int
      ; token_start : int
      ; end_ : int
      ; token_end : int
      ; label : string
      }

    val to_yojson : t -> Yojson.Safe.t

    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

    val pp : Format.formatter -> t -> unit

    val show : t -> string

    val make
      :  start:int
      -> token_start:int
      -> end_:int
      -> token_end:int
      -> label:string
      -> t

    type sequence = t list

    val sequence_to_yojson : sequence -> Yojson.Safe.t

    val sequence_of_yojson
      :  Yojson.Safe.t
      -> sequence Ppx_deriving_yojson_runtime.error_or

    val start : t -> int

    val token_start : t -> int

    val end_ : t -> int

    val token_end : t -> int

    val label : t -> string
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

  val pp : Format.formatter -> t -> unit

  val show : t -> string

  val start : t -> int

  val token_start : t -> int

  val end_ : t -> int

  val token_end : t -> int

  val label : t -> string

  val validate : definition:Definition.t -> 'a -> ('a, 'b) result

  val make
    :  definition:Definition.t persisted_definition
    -> start:int
    -> token_start:int
    -> end_:int
    -> token_end:int
    -> label:string
    -> (t, 'a) result
end

module Sequence : sig
  module Definition : sig
    type 'a t =
      { min_count : int option
      ; max_count : int option
      ; element_definition : 'a
      }

    val to_yojson : ('a -> Yojson.Safe.t) -> 'a t -> Yojson.Safe.t

    val of_yojson
      :  (Yojson.Safe.t -> 'a Ppx_deriving_yojson_runtime.error_or)
      -> Yojson.Safe.t
      -> 'a t Ppx_deriving_yojson_runtime.error_or

    val pp
      :  (Format.formatter -> 'a -> unit)
      -> Format.formatter
      -> 'a t
      -> unit

    val show : (Format.formatter -> 'a -> unit) -> 'a t -> string

    val min_count : 'a t -> int option

    val max_count : 'a t -> int option

    val element_definition : 'a t -> 'a

    val make : ?min_count:int -> ?max_count:int -> definition:'a -> unit -> 'a t
  end

  type 'a t =
    { definition_id : int
    ; feature : 'a list
    }

  val to_yojson : ('a -> Yojson.Safe.t) -> 'a t -> Yojson.Safe.t

  val of_yojson
    :  (Yojson.Safe.t -> 'a Ppx_deriving_yojson_runtime.error_or)
    -> Yojson.Safe.t
    -> 'a t Ppx_deriving_yojson_runtime.error_or

  val pp : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a t -> unit

  val show : (Format.formatter -> 'a -> unit) -> 'a t -> string

  val elements : 'a t -> 'a list

  val validate : definition:'a Definition.t -> 'b -> ('b, 'c) result

  val make
    :  definition:'a Definition.t persisted_definition
    -> 'b list
    -> ('b t, 'c) result
end

type definition_spec =
  | Image_def of Image.Definition.t
  | Text_def of Text.Definition.t
  | Bbox_def of Bbox.Definition.t
  | Label_def of Label.Definition.t
  | Number_def of Number.Definition.t
  | Tokens_def of Tokens.Definition.t
  | Entity_def of Entity.Definition.t
  | Sequence_def of definition_spec Sequence.Definition.t

val definition_spec_to_yojson : definition_spec -> Yojson.Safe.t

val definition_spec_of_yojson
  :  Yojson.Safe.t
  -> definition_spec Ppx_deriving_yojson_runtime.error_or

val pp_definition_spec : Format.formatter -> definition_spec -> unit

val show_definition_spec : definition_spec -> string

type definition = definition_spec persisted_definition

val definition_to_yojson : definition -> Yojson.Safe.t

val definition_of_yojson
  :  Yojson.Safe.t
  -> definition Ppx_deriving_yojson_runtime.error_or

val pp_definition : Format.formatter -> definition -> unit

val show_definition : definition -> string

type definition_list = definition list

val definition_list_to_yojson : definition_list -> Yojson.Safe.t

val definition_list_of_yojson
  :  Yojson.Safe.t
  -> definition_list Ppx_deriving_yojson_runtime.error_or

val pp_definition_list : Format.formatter -> definition_list -> unit

val show_definition_list : definition_list -> string

type feature =
  | Image of Image.t
  | Image_seq of Image.Feature.t Sequence.t
  | Text of Text.t
  | Bbox of Bbox.t
  | Bbox_seq of Bbox.Feature.t Sequence.t
  | Label of Label.t
  | Label_seq of Label.Feature.t Sequence.t
  | Number of Number.t
  | Number_seq of Number.Feature.t Sequence.t
  | Tokens of Tokens.t
  | Entity of Entity.t
  | Entity_seq of Entity.Feature.t Sequence.t

val feature_to_yojson : feature -> Yojson.Safe.t

val feature_of_yojson
  :  Yojson.Safe.t
  -> feature Ppx_deriving_yojson_runtime.error_or

val pp_feature : Format.formatter -> feature -> unit

val show_feature : feature -> string

type feature_list = feature list

val feature_list_to_yojson : feature_list -> Yojson.Safe.t

val feature_list_of_yojson
  :  Yojson.Safe.t
  -> feature_list Ppx_deriving_yojson_runtime.error_or

val pp_feature_list : Format.formatter -> feature_list -> unit

val show_feature_list : feature_list -> string

type t =
  { id : int
  ; dataset_id : int
  ; split : string option
  ; features : feature list
  }

val to_yojson : t -> Yojson.Safe.t

val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or

val pp : Format.formatter -> t -> unit

val show : t -> string

val definition_id_of_feature : feature -> int

val id_of_definition : 'a persisted_definition -> int

val feature_name_of_definition : 'a persisted_definition -> string

val dataset_id_of_definition : 'a persisted_definition -> int

val feature_type_of_definition_spec : definition_spec -> Feature_type.t

val feature_type_of_feature : feature -> Feature_type.t

val encode_definition_spec : definition_spec -> string

val decode_definition_spec
  :  feature_type:Feature_type.t
  -> string
  -> definition_spec

val encode_feature : feature -> string
