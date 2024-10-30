open Tyxml.Html

module Not_found = struct
  let createElement () = Layout.make ~title:"Page not found · Sapiens" [ h1 [ txt "Not found!" ] ]
end

let not_found = Not_found.createElement ()

module Features_analytics = struct
  let createElement () =
    Layout.make
      ~title:"Analytics · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Analytics"
          ~subtitle:"Analyse your dataset and get insights on how to improve them."
          ()
      ; Marketing_layout.footer ()
      ]
end

let features_analytics () = Features_analytics.createElement ()

module Features_annotation = struct
  let createElement () =
    Layout.make
      ~title:"Annotation · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Annotation"
          ~subtitle:"Transform your raw data into quality machine learning datasets."
          ()
      ; Marketing_layout.footer ()
      ]
end

let features_annotation () = Features_annotation.createElement ()

module Features_model_training = struct
  let createElement () =
    Layout.make
      ~title:"Model training · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Model training"
          ~subtitle:"Train state-of-the-art machine learning models in one click."
          ()
      ; Marketing_layout.footer ()
      ]
end

let features_model_training () = Features_model_training.createElement ()

module Features_model_deployment = struct
  let createElement () =
    Layout.make
      ~title:"Model deployment · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Model deployment"
          ~subtitle:"Deploy and monitor APIs to serve your machine learning models."
          ()
      ; Marketing_layout.footer ()
      ]
end

let features_model_deployment () = Features_model_deployment.createElement ()

module Terms = struct
  let createElement () =
    Layout.make
      ~title:"Terms · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Terms"
          ~subtitle:
            "Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui lorem cupidatat commodo. Elit sunt amet \
             fugiat veniam occaecat fugiat aliqua."
          ()
      ; Marketing_layout.footer ()
      ]
end

let terms () = Terms.createElement ()

module Privacy = struct
  let createElement () =
    Layout.make
      ~title:"Privacy · Sapiens"
      [ Marketing_navbar.make ()
      ; Marketing_layout.simple_hero
          ~title:"Privacy"
          ~subtitle:
            "Anim aute id magna aliqua ad ad non deserunt sunt. Qui irure qui lorem cupidatat commodo. Elit sunt amet \
             fugiat veniam occaecat fugiat aliqua."
          ()
      ; Marketing_layout.footer ()
      ]
end

let privacy () = Privacy.createElement ()
