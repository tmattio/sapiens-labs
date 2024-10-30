module Feature_type = struct
  type t =
    | Image
    | Text
    | Bbox
    | Label
    | Number
    | Tokens
    | Entity
    | Sequence of t
  [@@deriving yojson]

  type sequence = t list [@@deriving yojson]
end

module Feature_name = struct
  open Std.Result.Syntax

  type t = string [@@deriving yojson, show]

  let validate s =
    if String.length s <= 60 then
      Ok s
    else
      Error
        (`Validation_error
          "The feature name must contain at most 60 characters")

  let of_string s =
    let+ _result = validate s in
    s

  let to_string s = s
end

module Split = struct
  open Std.Result.Syntax

  type t = string [@@deriving yojson, show]

  let validate s =
    if String.length s <= 60 then
      Ok s
    else
      Error
        (`Validation_error
          "The feature name must contain at most 60 characters")

  let of_string s =
    let+ _result = validate s in
    s

  let to_string s = s
end

type 'a persisted_definition =
  { id : int
  ; dataset_id : int
  ; feature_name : Feature_name.t
  ; spec : 'a
  }
[@@deriving yojson, show]

module Image = struct
  module Definition = struct
    type t =
      { height : int option
      ; width : int option
      ; channels : int
      }
    [@@deriving yojson, show]

    let height t = t.height

    let width t = t.width

    let channels t = t.channels

    let make ?height ?width ?(channels = 3) () = { height; width; channels }
  end

  module Feature = struct
    type t =
      { url : string
      ; height : int
      ; width : int
      ; channels : int
      }
    [@@deriving yojson, show, make]

    type sequence = t list [@@deriving yojson]

    let url t = t.url

    let height t = t.height

    let width t = t.width

    let channels t = t.channels
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let url t = t.feature.url

  let height t = t.feature.height

  let width t = t.feature.width

  let channels t = t.feature.channels

  let validate ~(definition : Definition.t) t =
    let open Std.Result.Syntax in
    let* _ =
      match definition.height with
      | Some height when t.feature.height != height ->
        Error
          (`Validation_error
            "The height does not match the feature definition.")
      | _ ->
        Ok ()
    in
    let* _ =
      match definition.width with
      | Some width when t.feature.width != width ->
        Error
          (`Validation_error "The width does not match the feature definition.")
      | _ ->
        Ok ()
    in
    let* _ =
      match definition.channels == t.feature.channels with
      | false ->
        Error
          (`Validation_error
            "The channels do not match the feature definition.")
      | true ->
        Ok ()
    in
    Ok t

  let make
      ~(definition : Definition.t persisted_definition)
      ~url
      ~height
      ~width
      ~channels
    =
    validate
      ~definition:definition.spec
      { definition_id = definition.id
      ; feature = { url; height; width; channels }
      }
end

module Text = struct
  module Definition = struct
    type t = unit [@@deriving yojson, show]

    let make () = ()
  end

  module Feature = struct
    type t = { text : string } [@@deriving yojson, show]

    type sequence = t list [@@deriving yojson]

    let value t = t.text

    let make text = { text }
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let value t = t.feature.text

  let validate ~(definition : Definition.t) t =
    let _ = definition in
    Ok t

  let make ~(definition : Definition.t persisted_definition) text =
    validate
      ~definition:definition.spec
      { definition_id = definition.id; feature = { text } }
end

module Bbox = struct
  module Definition = struct
    type t = unit [@@deriving yojson, show]

    let make () = ()
  end

  module Feature = struct
    type t =
      { y_min : float
      ; x_min : float
      ; y_max : float
      ; x_max : float
      }
    [@@deriving yojson, show, make]

    type sequence = t list [@@deriving yojson]

    let y_min t = t.y_min

    let x_min t = t.x_min

    let y_max t = t.y_max

    let x_max t = t.x_max
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let y_min t = t.feature.y_min

  let x_min t = t.feature.x_min

  let y_max t = t.feature.y_max

  let x_max t = t.feature.x_max

  let validate ~(definition : Definition.t) t =
    let _ = definition in
    Ok t

  let make
      ~(definition : Definition.t persisted_definition)
      ~y_min
      ~x_min
      ~y_max
      ~x_max
    =
    validate
      ~definition:definition.spec
      { definition_id = definition.id
      ; feature = { y_min; x_min; y_max; x_max }
      }
end

module Label = struct
  module Definition = struct
    type t = { classes : string list } [@@deriving yojson, show]

    let classes t = t.classes

    let make ~classes = { classes }
  end

  module Feature = struct
    type t = { label : string } [@@deriving yojson, show]

    type sequence = t list [@@deriving yojson]

    let value t = t.label

    let make label = { label }
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let value t = t.feature.label

  let validate ~(definition : Definition.t) t =
    (* TODO: validate *)
    let _ = definition in
    Ok t

  let make ~(definition : Definition.t persisted_definition) label =
    validate
      ~definition:definition.spec
      { definition_id = definition.id; feature = { label } }
end

module Number = struct
  module Definition = struct
    type t =
      { min : float option
      ; max : float option
      }
    [@@deriving yojson, show]

    let min t = t.min

    let max t = t.max

    let make ?min ?max () = { min; max }
  end

  module Feature = struct
    type t = { value : float } [@@deriving yojson, show]

    type sequence = t list [@@deriving yojson]

    let value t = t.value

    let make value = { value }
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let value t = t.feature.value

  let validate ~(definition : Definition.t) t =
    (* TODO: validate *)
    let _ = definition in
    Ok t

  let make ~(definition : Definition.t persisted_definition) value =
    validate
      ~definition:definition.spec
      { definition_id = definition.id; feature = { value } }
end

module Tokens = struct
  type token =
    { text : string
    ; start : int
    ; end_ : int
    }
  [@@deriving yojson, show]

  module Definition = struct
    type t = unit [@@deriving yojson, show]

    let make () = ()
  end

  module Feature = struct
    type t = token list [@@deriving yojson, show]

    let tokens t = t

    let make t = t
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let tokens t = t.feature

  let validate ~(definition : Definition.t) t =
    let _ = definition in
    Ok t

  let make ~(definition : Definition.t persisted_definition) tokens =
    validate
      ~definition:definition.spec
      { definition_id = definition.id; feature = tokens }
end

module Entity = struct
  module Definition = struct
    type t = { classes : string list } [@@deriving yojson, show]

    let classes t = t.classes

    let make ~classes = { classes }
  end

  module Feature = struct
    type t =
      { start : int
      ; token_start : int
      ; end_ : int
      ; token_end : int
      ; label : string
      }
    [@@deriving yojson, show, make]

    type sequence = t list [@@deriving yojson]

    let start t = t.start

    let token_start t = t.token_start

    let end_ t = t.end_

    let token_end t = t.token_end

    let label t = t.label
  end

  type t =
    { definition_id : int
    ; feature : Feature.t
    }
  [@@deriving yojson, show]

  let start t = t.feature.start

  let token_start t = t.feature.token_start

  let end_ t = t.feature.end_

  let token_end t = t.feature.token_end

  let label t = t.feature.label

  let validate ~(definition : Definition.t) t =
    let _ = definition in
    Ok t

  let make
      ~(definition : Definition.t persisted_definition)
      ~start
      ~token_start
      ~end_
      ~token_end
      ~label
    =
    validate
      ~definition:definition.spec
      { definition_id = definition.id
      ; feature = { start; token_start; end_; token_end; label }
      }
end

module Sequence = struct
  module Definition = struct
    type 'a t =
      { min_count : int option
      ; max_count : int option
      ; element_definition : 'a
      }
    [@@deriving yojson, show]

    let min_count t = t.min_count

    let max_count t = t.max_count

    let element_definition t = t.element_definition

    let make ?min_count ?max_count ~definition () =
      { min_count; max_count; element_definition = definition }
  end

  type 'a t =
    { definition_id : int
    ; feature : 'a list
    }
  [@@deriving yojson, show]

  let elements t = t.feature

  let validate ~(definition : 'a Definition.t) t =
    let _ = definition in
    Ok t

  let make ~(definition : 'a Definition.t persisted_definition) elements =
    validate
      ~definition:definition.spec
      { definition_id = definition.id; feature = elements }
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
[@@deriving yojson, show]

type definition = definition_spec persisted_definition [@@deriving yojson, show]

type definition_list = definition list [@@deriving yojson, show]

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
[@@deriving yojson, show]

type feature_list = feature list [@@deriving yojson, show]

type t =
  { id : int
  ; dataset_id : int
  ; split : Split.t option
  ; features : feature list
  }
[@@deriving yojson, show]

let definition_id_of_feature (t : feature) =
  match t with
  | Image { definition_id; _ }
  | Image_seq { definition_id; _ }
  | Text { definition_id; _ }
  | Bbox { definition_id; _ }
  | Bbox_seq { definition_id; _ }
  | Label { definition_id; _ }
  | Label_seq { definition_id; _ }
  | Number { definition_id; _ }
  | Number_seq { definition_id; _ }
  | Tokens { definition_id; _ }
  | Entity { definition_id; _ }
  | Entity_seq { definition_id; _ } ->
    definition_id

let id_of_definition (t : 'a persisted_definition) = t.id

let feature_name_of_definition (t : 'a persisted_definition) = t.feature_name

let dataset_id_of_definition (t : 'a persisted_definition) = t.dataset_id

let rec feature_type_of_definition_spec = function
  | Image_def _ ->
    Feature_type.Image
  | Text_def _ ->
    Feature_type.Text
  | Bbox_def _ ->
    Feature_type.Bbox
  | Label_def _ ->
    Feature_type.Label
  | Number_def _ ->
    Feature_type.Number
  | Tokens_def _ ->
    Feature_type.Tokens
  | Entity_def _ ->
    Feature_type.Entity
  | Sequence_def spec ->
    Feature_type.Sequence
      (feature_type_of_definition_spec spec.element_definition)

let feature_type_of_feature (t : feature) =
  match t with
  | Image _ ->
    Feature_type.Image
  | Image_seq _ ->
    Feature_type.Sequence Feature_type.Image
  | Text _ ->
    Feature_type.Text
  | Bbox _ ->
    Feature_type.Bbox
  | Bbox_seq _ ->
    Feature_type.Sequence Feature_type.Bbox
  | Label _ ->
    Feature_type.Label
  | Label_seq _ ->
    Feature_type.Sequence Feature_type.Label
  | Number _ ->
    Feature_type.Number
  | Number_seq _ ->
    Feature_type.Sequence Feature_type.Number
  | Tokens _ ->
    Feature_type.Tokens
  | Entity _ ->
    Feature_type.Entity
  | Entity_seq _ ->
    Feature_type.Sequence Feature_type.Entity

let encode_definition_spec t =
  let rec aux = function
    | Image_def x ->
      Image.Definition.to_yojson x
    | Text_def x ->
      Text.Definition.to_yojson x
    | Bbox_def x ->
      Bbox.Definition.to_yojson x
    | Label_def x ->
      Label.Definition.to_yojson x
    | Number_def x ->
      Number.Definition.to_yojson x
    | Tokens_def x ->
      Tokens.Definition.to_yojson x
    | Entity_def x ->
      Entity.Definition.to_yojson x
    | Sequence_def x ->
      Sequence.Definition.to_yojson aux x
  in
  aux t |> Yojson.Safe.to_string

let decode_definition_spec ~feature_type t =
  let rec aux feature_type =
    let open Std.Result.Syntax in
    fun x ->
      match feature_type with
      | Feature_type.Image ->
        let+ r = Image.Definition.of_yojson x in
        Image_def r
      | Feature_type.Text ->
        let+ r = Text.Definition.of_yojson x in
        Text_def r
      | Feature_type.Bbox ->
        let+ r = Bbox.Definition.of_yojson x in
        Bbox_def r
      | Feature_type.Label ->
        let+ r = Label.Definition.of_yojson x in
        Label_def r
      | Feature_type.Number ->
        let+ r = Number.Definition.of_yojson x in
        Number_def r
      | Feature_type.Tokens ->
        let+ r = Tokens.Definition.of_yojson x in
        Tokens_def r
      | Feature_type.Entity ->
        let+ r = Entity.Definition.of_yojson x in
        Entity_def r
      | Feature_type.Sequence feat ->
        let f = aux feat in
        let+ r = Sequence.Definition.of_yojson f x in
        Sequence_def r
  in
  let decode_with decoder =
    match t |> Yojson.Safe.from_string |> decoder with
    | Ok t ->
      t
    | Error err ->
      failwith ("The feature definition could not be decoded: " ^ err)
  in
  decode_with (aux feature_type)

let encode_feature (t : feature) =
  match t with
  | Image { feature; _ } ->
    Image.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Image_seq { feature; _ } ->
    Image.Feature.sequence_to_yojson feature |> Yojson.Safe.to_string
  | Text { feature; _ } ->
    Text.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Bbox { feature; _ } ->
    Bbox.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Bbox_seq { feature; _ } ->
    Bbox.Feature.sequence_to_yojson feature |> Yojson.Safe.to_string
  | Label { feature; _ } ->
    Label.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Label_seq { feature; _ } ->
    Label.Feature.sequence_to_yojson feature |> Yojson.Safe.to_string
  | Number { feature; _ } ->
    Number.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Number_seq { feature; _ } ->
    Number.Feature.sequence_to_yojson feature |> Yojson.Safe.to_string
  | Tokens { feature; _ } ->
    Tokens.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Entity { feature; _ } ->
    Entity.Feature.to_yojson feature |> Yojson.Safe.to_string
  | Entity_seq { feature; _ } ->
    Entity.Feature.sequence_to_yojson feature |> Yojson.Safe.to_string
