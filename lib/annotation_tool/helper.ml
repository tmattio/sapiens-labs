open Sapiens_common

let non_annotated (annotations : Annotation.Annotation.t list) =
  List.filter
    (fun el ->
      match el.Annotation.Annotation.annotated_at with
      | Some _ ->
        false
      | None ->
        true)
    annotations

let index_first_non_annotated (annotations : Annotation.Annotation.t list) =
  let rec aux i l =
    match l with
    | [] ->
      None
    | el :: rest ->
      (match el.Annotation.Annotation.annotated_at with
      | None ->
        Some i
      | Some _ ->
        aux (i + 1) rest)
  in
  aux 0 annotations

let first_non_annotated (annotations : Annotation.Annotation.t list) =
  match non_annotated annotations with [] -> None | el :: _rest -> Some el

let count_annotations (annotations : Annotation.Annotation.t list) =
  List.length annotations

let count_non_annotated (annotations : Annotation.Annotation.t list) =
  annotations |> non_annotated |> List.length

let count_annotated (annotations : Annotation.Annotation.t list) =
  let total = count_annotations annotations in
  let completed = count_non_annotated annotations in
  total - completed

let pct_completed (annotations : Annotation.Annotation.t list) =
  let total = float_of_int (count_annotations annotations) in
  let completed = float_of_int (count_annotated annotations) in
  int_of_float ((1. -. ((total -. completed) /. total)) *. 100.)

let get_label_feat (hashtbl : (int, Datapoint.feature) Hashtbl.t) (id : int)
    : string option
  =
  match Hashtbl.find_opt hashtbl id with
  | None ->
    None
  | Some (Datapoint.Label { feature = { label }; _ }) ->
    Some label
  | Some _ ->
    None

let set_label_feat
    (hashtbl : (int, Datapoint.feature) Hashtbl.t) (id : int) (feat : string)
  =
  Hashtbl.replace
    hashtbl
    id
    (Datapoint.Label { definition_id = id; feature = { label = feat } })

let get_number_feat (hashtbl : (int, Datapoint.feature) Hashtbl.t) (id : int)
    : float option
  =
  match Hashtbl.find_opt hashtbl id with
  | None ->
    None
  | Some (Datapoint.Number { feature = { value }; _ }) ->
    Some value
  | Some _ ->
    None

let set_number_feat
    (hashtbl : (int, Datapoint.feature) Hashtbl.t) (id : int) (feat : float)
  =
  Hashtbl.replace
    hashtbl
    id
    (Datapoint.Number { definition_id = id; feature = { value = feat } })

let get_label_seq_feat (hashtbl : (int, Datapoint.feature) Hashtbl.t) (id : int)
    : string list
  =
  match Hashtbl.find_opt hashtbl id with
  | None ->
    []
  | Some (Datapoint.Label_seq { feature = labels; _ }) ->
    let labels =
      List.map (fun Datapoint.Label.Feature.{ label } -> label) labels
    in
    labels
  | Some _ ->
    []

let set_label_seq_feat
    (hashtbl : (int, Datapoint.feature) Hashtbl.t)
    (id : int)
    (feat : string list)
  =
  Hashtbl.replace
    hashtbl
    id
    (Datapoint.Label_seq
       { definition_id = id
       ; feature =
           List.map (fun label -> Datapoint.Label.Feature.{ label }) feat
       })

let features_of_hashtbl hashtbl =
  Hashtbl.fold (fun _k v acc -> v :: acc) hashtbl []

let hashtbl_of_features features =
  features
  |> List.map (fun x -> Sapiens_common.Datapoint.definition_id_of_feature x, x)
  |> List.to_seq
  |> Hashtbl.of_seq

let window = Js_of_ocaml.Dom_html.window

let scroll_top () = window##scroll 0 0
