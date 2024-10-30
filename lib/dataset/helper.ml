open Sapiens_backend.Dataset.Datapoint

let text_def = Text_def (Text.Definition.make ())

let number_def = Number_def (Number.Definition.make ~min:0. ())

let image_def = Image_def (Image.Definition.make ())

let class_def classes = Label_def (Label.Definition.make ~classes)

let seq_class_def ?min ?max classes =
  Sequence_def
    (Sequence.Definition.make
       ?min_count:min
       ?max_count:max
       ~definition:(Label_def (Label.Definition.make ~classes))
       ())

let text ~def t = Text (Text.make ~definition:def t |> Result.get_ok)

let number ~def t = Number (Number.make ~definition:def t |> Result.get_ok)

let image ~def url =
  Image
    (Image.make ~definition:def ~height:0 ~width:0 ~channels:3 ~url
    |> Result.get_ok)

let class_ ~def t = Label (Label.make ~definition:def t |> Result.get_ok)

let seq_class
    ~(def : Label.Definition.t Sequence.Definition.t persisted_definition)
    classes
  =
  let classes = List.map (fun el -> Label.Feature.make el) classes in
  Label_seq (Sequence.make ~definition:def classes |> Result.get_ok)
