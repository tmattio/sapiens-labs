open Js_of_ocaml
open Tyxml_lwd
open Html_types

module Pure_html : sig
  include module type of struct
    include Html
  end

  val a_class : nmtokens -> [> `Class ] attrib

  val a_user_data : string -> string -> [> `User_data ] attrib

  val a_id : string -> [> `Id ] attrib

  val a_title : string -> [> `Title ] attrib

  val a_xml_lang : string -> [> `XML_lang ] attrib

  val a_lang : string -> [> `Lang ] attrib

  val a_onabort : (Dom_html.event Js.t -> bool) -> [> `OnAbort ] attrib

  val a_onafterprint
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnAfterPrint ] attrib

  val a_onbeforeprint
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnBeforePrint ] attrib

  val a_onbeforeunload
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnBeforeUnload ] attrib

  val a_onblur : (Dom_html.event Js.t -> bool) -> [> `OnBlur ] attrib

  val a_oncanplay : (Dom_html.event Js.t -> bool) -> [> `OnCanPlay ] attrib

  val a_oncanplaythrough
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnCanPlayThrough ] attrib

  val a_onchange : (Dom_html.event Js.t -> bool) -> [> `OnChange ] attrib

  val a_ondurationchange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnDurationChange ] attrib

  val a_onemptied : (Dom_html.event Js.t -> bool) -> [> `OnEmptied ] attrib

  val a_onended : (Dom_html.event Js.t -> bool) -> [> `OnEnded ] attrib

  val a_onerror : (Dom_html.event Js.t -> bool) -> [> `OnError ] attrib

  val a_onfocus : (Dom_html.event Js.t -> bool) -> [> `OnFocus ] attrib

  val a_onformchange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnFormChange ] attrib

  val a_onforminput : (Dom_html.event Js.t -> bool) -> [> `OnFormInput ] attrib

  val a_onhashchange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnHashChange ] attrib

  val a_oninput : (Dom_html.event Js.t -> bool) -> [> `OnInput ] attrib

  val a_oninvalid : (Dom_html.event Js.t -> bool) -> [> `OnInvalid ] attrib

  val a_onmousewheel
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnMouseWheel ] attrib

  val a_onoffline : (Dom_html.event Js.t -> bool) -> [> `OnOffLine ] attrib

  val a_ononline : (Dom_html.event Js.t -> bool) -> [> `OnOnLine ] attrib

  val a_onpause : (Dom_html.event Js.t -> bool) -> [> `OnPause ] attrib

  val a_onplay : (Dom_html.event Js.t -> bool) -> [> `OnPlay ] attrib

  val a_onplaying : (Dom_html.event Js.t -> bool) -> [> `OnPlaying ] attrib

  val a_onpagehide : (Dom_html.event Js.t -> bool) -> [> `OnPageHide ] attrib

  val a_onpageshow : (Dom_html.event Js.t -> bool) -> [> `OnPageShow ] attrib

  val a_onpopstate : (Dom_html.event Js.t -> bool) -> [> `OnPopState ] attrib

  val a_onprogress : (Dom_html.event Js.t -> bool) -> [> `OnProgress ] attrib

  val a_onratechange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnRateChange ] attrib

  val a_onreadystatechange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnReadyStateChange ] attrib

  val a_onredo : (Dom_html.event Js.t -> bool) -> [> `OnRedo ] attrib

  val a_onresize : (Dom_html.event Js.t -> bool) -> [> `OnResize ] attrib

  val a_onscroll : (Dom_html.event Js.t -> bool) -> [> `OnScroll ] attrib

  val a_onseeked : (Dom_html.event Js.t -> bool) -> [> `OnSeeked ] attrib

  val a_onseeking : (Dom_html.event Js.t -> bool) -> [> `OnSeeking ] attrib

  val a_onselect : (Dom_html.event Js.t -> bool) -> [> `OnSelect ] attrib

  val a_onshow : (Dom_html.event Js.t -> bool) -> [> `OnShow ] attrib

  val a_onstalled : (Dom_html.event Js.t -> bool) -> [> `OnStalled ] attrib

  val a_onstorage : (Dom_html.event Js.t -> bool) -> [> `OnStorage ] attrib

  val a_onsubmit : (Dom_html.event Js.t -> bool) -> [> `OnSubmit ] attrib

  val a_onsuspend : (Dom_html.event Js.t -> bool) -> [> `OnSuspend ] attrib

  val a_ontimeupdate
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnTimeUpdate ] attrib

  val a_onundo : (Dom_html.event Js.t -> bool) -> [> `OnUndo ] attrib

  val a_onunload : (Dom_html.event Js.t -> bool) -> [> `OnUnload ] attrib

  val a_onvolumechange
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnVolumeChange ] attrib

  val a_onwaiting : (Dom_html.event Js.t -> bool) -> [> `OnWaiting ] attrib

  val a_onload : (Dom_html.event Js.t -> bool) -> [> `OnLoad ] attrib

  val a_onloadeddata
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnLoadedData ] attrib

  val a_onloadedmetadata
    :  (Dom_html.event Js.t -> bool)
    -> [> `OnLoadedMetaData ] attrib

  val a_onloadstart : (Dom_html.event Js.t -> bool) -> [> `OnLoadStart ] attrib

  val a_onmessage : (Dom_html.event Js.t -> bool) -> [> `OnMessage ] attrib

  val a_onclick : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnClick ] attrib

  val a_oncontextmenu
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnContextMenu ] attrib

  val a_ondblclick
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnDblClick ] attrib

  val a_ondrag : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnDrag ] attrib

  val a_ondragend : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnDragEnd ] attrib

  val a_ondragenter
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnDragEnter ] attrib

  val a_ondragleave
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnDragLeave ] attrib

  val a_ondragover
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnDragOver ] attrib

  val a_ondragstart
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnDragStart ] attrib

  val a_ondrop : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnDrop ] attrib

  val a_onmousedown
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseDown ] attrib

  val a_onmouseup : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnMouseUp ] attrib

  val a_onmouseover
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseOver ] attrib

  val a_onmousemove
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseMove ] attrib

  val a_onmouseout
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseOut ] attrib

  val a_ontouchstart
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchStart ] attrib

  val a_ontouchend
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchEnd ] attrib

  val a_ontouchmove
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchMove ] attrib

  val a_ontouchcancel
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchCancel ] attrib

  val a_onkeypress
    :  (Dom_html.keyboardEvent Js.t -> bool)
    -> [> `OnKeyPress ] attrib

  val a_onkeydown
    :  (Dom_html.keyboardEvent Js.t -> bool)
    -> [> `OnKeyDown ] attrib

  val a_onkeyup : (Dom_html.keyboardEvent Js.t -> bool) -> [> `OnKeyUp ] attrib

  val a_autocomplete : bool -> [> `Autocomplete ] attrib

  val a_crossorigin
    :  [< `Anonymous | `Use_credentials ]
    -> [> `Crossorigin ] attrib

  val a_integrity : string -> [> `Integrity ] attrib

  val a_mediagroup : string -> [> `Mediagroup ] attrib

  val a_challenge : string -> [> `Challenge ] attrib

  val a_contenteditable : bool -> [> `Contenteditable ] attrib

  val a_contextmenu : string -> [> `Contextmenu ] attrib

  val a_dir : [< `Ltr | `Rtl ] -> [> `Dir ] attrib

  val a_draggable : bool -> [> `Draggable ] attrib

  val a_form : string -> [> `Form ] attrib

  val a_formaction : Xml.uri -> [> `Formaction ] attrib

  val a_formenctype : string -> [> `Formenctype ] attrib

  val a_formtarget : string -> [> `Formtarget ] attrib

  val a_high : float -> [> `High ] attrib

  val a_icon : Xml.uri -> [> `Icon ] attrib

  val a_keytype : string -> [> `Keytype ] attrib

  val a_list : string -> [> `List ] attrib

  val a_low : float -> [> `High ] attrib

  val a_max : float -> [> `Max ] attrib

  val a_input_max : number_or_datetime -> [> `Input_Max ] attrib

  val a_min : float -> [> `Min ] attrib

  val a_input_min : number_or_datetime -> [> `Input_Min ] attrib

  val a_inputmode
    :  [< `Email
       | `Full_width_latin
       | `Kana
       | `Katakana
       | `Latin
       | `Latin_name
       | `Latin_prose
       | `Numeric
       | `Tel
       | `Url
       | `Verbatim
       ]
    -> [> `Inputmode ] attrib

  val a_optimum : float -> [> `Optimum ] attrib

  val a_pattern : string -> [> `Pattern ] attrib

  val a_placeholder : string -> [> `Placeholder ] attrib

  val a_poster : Xml.uri -> [> `Poster ] attrib

  val a_preload : [< `Audio | `Metadata | `None ] -> [> `Preload ] attrib

  val a_radiogroup : string -> [> `Radiogroup ] attrib

  val a_referrerpolicy : referrerpolicy -> [> `Referrerpolicy ] attrib

  val a_sandbox : [< sandbox_token ] list -> [> `Sandbox ] attrib

  val a_spellcheck : bool -> [> `Spellcheck ] attrib

  val a_sizes : (int * int) list option -> [> `Sizes ] attrib

  val a_span : int -> [> `Span ] attrib

  val a_srcset : image_candidate list -> [> `Srcset ] attrib

  val a_img_sizes : string list -> [> `Img_sizes ] attrib

  val a_start : int -> [> `Start ] attrib

  val a_step : float option -> [> `Step ] attrib

  val a_wrap : [< `Hard | `Soft ] -> [> `Wrap ] attrib

  val a_version : string -> [> `Version ] attrib

  val a_xmlns : [< `W3_org_1999_xhtml ] -> [> `XMLns ] attrib

  val a_manifest : Xml.uri -> [> `Manifest ] attrib

  val a_cite : Xml.uri -> [> `Cite ] attrib

  val a_xml_space : [< `Default | `Preserve ] -> [> `XML_space ] attrib

  val a_accesskey : char -> [> `Accesskey ] attrib

  val a_charset : string -> [> `Charset ] attrib

  val a_accept_charset : charsets -> [> `Accept_charset ] attrib

  val a_accept : contenttypes -> [> `Accept ] attrib

  val a_href : Xml.uri -> [> `Href ] attrib

  val a_hreflang : string -> [> `Hreflang ] attrib

  val a_download : string option -> [> `Download ] attrib

  val a_rel : linktypes -> [> `Rel ] attrib

  val a_tabindex : int -> [> `Tabindex ] attrib

  val a_mime_type : string -> [> `Mime_type ] attrib

  val a_datetime : string -> [> `Datetime ] attrib

  val a_action : Xml.uri -> [> `Action ] attrib

  val a_cols : int -> [> `Cols ] attrib

  val a_enctype : string -> [> `Enctype ] attrib

  val a_label_for : string -> [> `Label_for ] attrib

  val a_output_for : idrefs -> [> `Output_for ] attrib

  val a_maxlength : int -> [> `Maxlength ] attrib

  val a_minlength : int -> [> `Minlength ] attrib

  val a_method : [< `Get | `Post ] -> [> `Method ] attrib

  val a_name : string -> [> `Name ] attrib

  val a_rows : int -> [> `Rows ] attrib

  val a_size : int -> [> `Size ] attrib

  val a_src : Xml.uri -> [> `Src ] attrib

  val a_input_type
    :  [< `Button
       | `Checkbox
       | `Color
       | `Date
       | `Datetime
       | `Datetime_local
       | `Email
       | `File
       | `Hidden
       | `Image
       | `Month
       | `Number
       | `Password
       | `Radio
       | `Range
       | `Reset
       | `Search
       | `Submit
       | `Tel
       | `Text
       | `Time
       | `Url
       | `Week
       ]
    -> [> `Input_Type ] attrib

  val a_text_value : string -> [> `Text_Value ] attrib

  val a_int_value : int -> [> `Int_Value ] attrib

  val a_value : string -> [> `Value ] attrib

  val a_float_value : float -> [> `Float_Value ] attrib

  val a_button_type
    :  [< `Button | `Reset | `Submit ]
    -> [> `Button_Type ] attrib

  val a_command_type
    :  [< `Checkbox | `Command | `Radio ]
    -> [> `Command_Type ] attrib

  val a_menu_type : [< `Context | `Toolbar ] -> [> `Menu_Type ] attrib

  val a_label : string -> [> `Label ] attrib

  val a_colspan : int -> [> `Colspan ] attrib

  val a_headers : idrefs -> [> `Headers ] attrib

  val a_rowspan : int -> [> `Rowspan ] attrib

  val a_alt : string -> [> `Alt ] attrib

  val a_height : int -> [> `Height ] attrib

  val a_width : int -> [> `Width ] attrib

  val a_shape : shape -> [> `Shape ] attrib

  val a_coords : numbers -> [> `Coords ] attrib

  val a_usemap : string -> [> `Usemap ] attrib

  val a_data : Xml.uri -> [> `Data ] attrib

  val a_scrolling : [< `Auto | `No | `Yes ] -> [> `Scrolling ] attrib

  val a_target : string -> [> `Target ] attrib

  val a_content : string -> [> `Content ] attrib

  val a_http_equiv : string -> [> `Http_equiv ] attrib

  val a_media : mediadesc -> [> `Media ] attrib

  val a_style : string -> [> `Style_Attr ] attrib

  val a_property : string -> [> `Property ] attrib

  val a_role : string list -> [> `Role ] attrib

  val a_aria : string -> string list -> [> `Aria ] attrib

  val txt : string -> [> txt ] elt

  val bdo
    :  dir:[< `Ltr | `Rtl ]
    -> ([< bdo_attrib ], [< bdo_content_fun ], [> bdo ]) star

  val img : src:Xml.uri -> alt:string -> ([< img_attrib ], [> img ]) nullary

  val audio
    :  ?src:Xml.uri
    -> ?srcs:[< source ] elt list
    -> ([< audio_attrib ], 'a, [> 'a audio ]) star

  val video
    :  ?src:Xml.uri
    -> ?srcs:[< source ] elt list
    -> ([< video_attrib ], 'a, [> 'a video ]) star

  val area
    :  alt:string
    -> ( [< `Accesskey
         | `Alt
         | `Aria
         | `Class
         | `Contenteditable
         | `Contextmenu
         | `Coords
         | `Dir
         | `Draggable
         | `Hidden
         | `Hreflang
         | `Id
         | `Lang
         | `Media
         | `Mime_type
         | `OnAbort
         | `OnBlur
         | `OnCanPlay
         | `OnCanPlayThrough
         | `OnChange
         | `OnClick
         | `OnContextMenu
         | `OnDblClick
         | `OnDrag
         | `OnDragEnd
         | `OnDragEnter
         | `OnDragLeave
         | `OnDragOver
         | `OnDragStart
         | `OnDrop
         | `OnDurationChange
         | `OnEmptied
         | `OnEnded
         | `OnError
         | `OnFocus
         | `OnFormChange
         | `OnFormInput
         | `OnInput
         | `OnInvalid
         | `OnKeyDown
         | `OnKeyPress
         | `OnKeyUp
         | `OnLoad
         | `OnLoadStart
         | `OnLoadedData
         | `OnLoadedMetaData
         | `OnMouseDown
         | `OnMouseMove
         | `OnMouseOut
         | `OnMouseOver
         | `OnMouseUp
         | `OnMouseWheel
         | `OnPause
         | `OnPlay
         | `OnPlaying
         | `OnProgress
         | `OnRateChange
         | `OnReadyStateChange
         | `OnScroll
         | `OnSeeked
         | `OnSeeking
         | `OnSelect
         | `OnShow
         | `OnStalled
         | `OnSubmit
         | `OnSuspend
         | `OnTimeUpdate
         | `OnTouchCancel
         | `OnTouchEnd
         | `OnTouchMove
         | `OnTouchStart
         | `OnVolumeChange
         | `OnWaiting
         | `Rel
         | `Role
         | `Shape
         | `Spellcheck
         | `Style_Attr
         | `Tabindex
         | `Target
         | `Title
         | `User_data
         | `XML_lang
         | `XMLns
         ]
       , [> area ] )
       nullary

  val optgroup
    :  label:string
    -> ([< optgroup_attrib ], [< optgroup_content_fun ], [> optgroup ]) star

  val command : label:string -> ([< command_attrib ], [> command ]) nullary

  val link
    :  rel:linktypes
    -> href:Xml.uri
    -> ([< link_attrib ], [> link ]) nullary
end

open Svg_types

module Pure_svg : sig
  include module type of struct
    include Svg
  end

  val a_x : Unit.length -> [> `X ] attrib

  val a_y : Unit.length -> [> `Y ] attrib

  val a_width : Unit.length -> [> `Width ] attrib

  val a_height : Unit.length -> [> `Height ] attrib

  val a_preserveAspectRatio : uri -> [> `PreserveAspectRatio ] attrib

  val a_zoomAndPan : [< `Disable | `Magnify ] -> [> `ZoomAndSpan ] attrib

  val a_href : uri -> [> `Xlink_href ] attrib

  val a_requiredExtensions : spacestrings -> [> `RequiredExtension ] attrib

  val a_systemLanguage : commastrings -> [> `SystemLanguage ] attrib

  val a_externalRessourcesRequired
    :  bool
    -> [> `ExternalRessourcesRequired ] attrib

  val a_id : uri -> [> `Id ] attrib

  val a_user_data : uri -> uri -> [> `User_data ] attrib

  val a_xml_lang : uri -> [> `Xml_Lang ] attrib

  val a_type : uri -> [> `Type ] attrib

  val a_media : commastrings -> [> `Media ] attrib

  val a_class : spacestrings -> [> `Class ] attrib

  val a_style : uri -> [> `Style ] attrib

  val a_transform : transforms -> [> `Transform ] attrib

  val a_viewBox : fourfloats -> [> `ViewBox ] attrib

  val a_d : uri -> [> `D ] attrib

  val a_pathLength : float -> [> `PathLength ] attrib

  val a_rx : Unit.length -> [> `Rx ] attrib

  val a_ry : Unit.length -> [> `Ry ] attrib

  val a_cx : Unit.length -> [> `Cx ] attrib

  val a_cy : Unit.length -> [> `Cy ] attrib

  val a_r : Unit.length -> [> `R ] attrib

  val a_x1 : Unit.length -> [> `X1 ] attrib

  val a_y1 : Unit.length -> [> `Y1 ] attrib

  val a_x2 : Unit.length -> [> `X2 ] attrib

  val a_y2 : Unit.length -> [> `Y2 ] attrib

  val a_points : coords -> [> `Points ] attrib

  val a_x_list : lengths -> [> `X_list ] attrib

  val a_y_list : lengths -> [> `Y_list ] attrib

  val a_dx : float -> [> `Dx ] attrib

  val a_dy : float -> [> `Dy ] attrib

  val a_dx_list : lengths -> [> `Dx_list ] attrib

  val a_dy_list : lengths -> [> `Dy_list ] attrib

  val a_lengthAdjust
    :  [< `Spacing | `SpacingAndGlyphs ]
    -> [> `LengthAdjust ] attrib

  val a_textLength : Unit.length -> [> `TextLength ] attrib

  val a_text_anchor
    :  [< `End | `Inherit | `Middle | `Start ]
    -> [> `Text_Anchor ] attrib

  val a_text_decoration
    :  [< `Blink | `Inherit | `Line_through | `None | `Overline | `Underline ]
    -> [> `Text_Decoration ] attrib

  val a_text_rendering
    :  [< `Auto
       | `GeometricPrecision
       | `Inherit
       | `OptimizeLegibility
       | `OptimizeSpeed
       ]
    -> [> `Text_Rendering ] attrib

  val a_rotate : numbers -> [> `Rotate ] attrib

  val a_startOffset : Unit.length -> [> `StartOffset ] attrib

  val a_method : [< `Align | `Stretch ] -> [> `Method ] attrib

  val a_spacing : [< `Auto | `Exact ] -> [> `Spacing ] attrib

  val a_glyphRef : uri -> [> `GlyphRef ] attrib

  val a_format : uri -> [> `Format ] attrib

  val a_markerUnits
    :  [< `StrokeWidth | `UserSpaceOnUse ]
    -> [> `MarkerUnits ] attrib

  val a_refX : Unit.length -> [> `RefX ] attrib

  val a_refY : Unit.length -> [> `RefY ] attrib

  val a_markerWidth : Unit.length -> [> `MarkerWidth ] attrib

  val a_markerHeight : Unit.length -> [> `MarkerHeight ] attrib

  val a_orient : Unit.angle option -> [> `Orient ] attrib

  val a_local : uri -> [> `Local ] attrib

  val a_rendering_intent
    :  [< `Absolute_colorimetric
       | `Auto
       | `Perceptual
       | `Relative_colorimetric
       | `Saturation
       ]
    -> [> `Rendering_Indent ] attrib

  val a_gradientUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [ `GradientUnits ] attrib

  val a_gradientTransform : transforms -> [> `Gradient_Transform ] attrib

  val a_spreadMethod
    :  [< `Pad | `Reflect | `Repeat ]
    -> [> `SpreadMethod ] attrib

  val a_fx : Unit.length -> [> `Fx ] attrib

  val a_fy : Unit.length -> [> `Fy ] attrib

  val a_offset
    :  [< `Number of float | `Percentage of float ]
    -> [> `Offset ] attrib

  val a_patternUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `PatternUnits ] attrib

  val a_patternContentUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `PatternContentUnits ] attrib

  val a_patternTransform : transforms -> [> `PatternTransform ] attrib

  val a_clipPathUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `ClipPathUnits ] attrib

  val a_maskUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `MaskUnits ] attrib

  val a_maskContentUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `MaskContentUnits ] attrib

  val a_primitiveUnits
    :  [< `ObjectBoundingBox | `UserSpaceOnUse ]
    -> [> `PrimitiveUnits ] attrib

  val a_filterRes : number_optional_number -> [> `FilterResUnits ] attrib

  val a_result : uri -> [> `Result ] attrib

  val a_in
    :  [< `BackgroundAlpha
       | `BackgroundImage
       | `FillPaint
       | `Ref of uri
       | `SourceAlpha
       | `SourceGraphic
       | `StrokePaint
       ]
    -> [> `In ] attrib

  val a_in2
    :  [< `BackgroundAlpha
       | `BackgroundImage
       | `FillPaint
       | `Ref of uri
       | `SourceAlpha
       | `SourceGraphic
       | `StrokePaint
       ]
    -> [> `In2 ] attrib

  val a_azimuth : float -> [> `Azimuth ] attrib

  val a_elevation : float -> [> `Elevation ] attrib

  val a_pointsAtX : float -> [> `PointsAtX ] attrib

  val a_pointsAtY : float -> [> `PointsAtY ] attrib

  val a_pointsAtZ : float -> [> `PointsAtZ ] attrib

  val a_specularExponent : float -> [> `SpecularExponent ] attrib

  val a_specularConstant : float -> [> `SpecularConstant ] attrib

  val a_limitingConeAngle : float -> [> `LimitingConeAngle ] attrib

  val a_mode
    :  [< `Darken | `Lighten | `Multiply | `Normal | `Screen ]
    -> [> `Mode ] attrib

  val a_feColorMatrix_type
    :  [< `HueRotate | `LuminanceToAlpha | `Matrix | `Saturate ]
    -> [> `Typefecolor ] attrib

  val a_values : numbers -> [> `Values ] attrib

  val a_transfer_type
    :  [< `Discrete | `Gamma | `Identity | `Linear | `Table ]
    -> [> `Type_transfert ] attrib

  val a_tableValues : numbers -> [> `TableValues ] attrib

  val a_intercept : float -> [> `Intercept ] attrib

  val a_amplitude : float -> [> `Amplitude ] attrib

  val a_exponent : float -> [> `Exponent ] attrib

  val a_transfer_offset : float -> [> `Offset_transfer ] attrib

  val a_feComposite_operator
    :  [< `Arithmetic | `Atop | `In | `Out | `Over | `Xor ]
    -> [> `OperatorComposite ] attrib

  val a_k1 : float -> [> `K1 ] attrib

  val a_k2 : float -> [> `K2 ] attrib

  val a_k3 : float -> [> `K3 ] attrib

  val a_k4 : float -> [> `K4 ] attrib

  val a_order : number_optional_number -> [> `Order ] attrib

  val a_kernelMatrix : numbers -> [> `KernelMatrix ] attrib

  val a_divisor : float -> [> `Divisor ] attrib

  val a_bias : float -> [> `Bias ] attrib

  val a_kernelUnitLength
    :  number_optional_number
    -> [> `KernelUnitLength ] attrib

  val a_targetX : int -> [> `TargetX ] attrib

  val a_targetY : int -> [> `TargetY ] attrib

  val a_edgeMode : [< `Duplicate | `None | `Wrap ] -> [> `TargetY ] attrib

  val a_preserveAlpha : bool -> [> `TargetY ] attrib

  val a_surfaceScale : float -> [> `SurfaceScale ] attrib

  val a_diffuseConstant : float -> [> `DiffuseConstant ] attrib

  val a_scale : float -> [> `Scale ] attrib

  val a_xChannelSelector
    :  [< `A | `B | `G | `R ]
    -> [> `XChannelSelector ] attrib

  val a_yChannelSelector
    :  [< `A | `B | `G | `R ]
    -> [> `YChannelSelector ] attrib

  val a_stdDeviation : number_optional_number -> [> `StdDeviation ] attrib

  val a_feMorphology_operator
    :  [< `Dilate | `Erode ]
    -> [> `OperatorMorphology ] attrib

  val a_radius : number_optional_number -> [> `Radius ] attrib

  val a_baseFrenquency : number_optional_number -> [> `BaseFrequency ] attrib

  val a_numOctaves : int -> [> `NumOctaves ] attrib

  val a_seed : float -> [> `Seed ] attrib

  val a_stitchTiles : [< `NoStitch | `Stitch ] -> [> `StitchTiles ] attrib

  val a_feTurbulence_type
    :  [< `FractalNoise | `Turbulence ]
    -> [> `TypeStitch ] attrib

  val a_target : uri -> [> `Xlink_target ] attrib

  val a_attributeName : uri -> [> `AttributeName ] attrib

  val a_attributeType : [< `Auto | `CSS | `XML ] -> [> `AttributeType ] attrib

  val a_begin : uri -> [> `Begin ] attrib

  val a_dur : uri -> [> `Dur ] attrib

  val a_min : uri -> [> `Min ] attrib

  val a_max : uri -> [> `Max ] attrib

  val a_restart : [< `Always | `Never | `WhenNotActive ] -> [> `Restart ] attrib

  val a_repeatCount : uri -> [> `RepeatCount ] attrib

  val a_repeatDur : uri -> [> `RepeatDur ] attrib

  val a_fill : paint -> [> `Fill ] attrib

  val a_animation_fill : [< `Freeze | `Remove ] -> [> `Fill_Animation ] attrib

  val a_calcMode
    :  [< `Discrete | `Linear | `Paced | `Spline ]
    -> [> `CalcMode ] attrib

  val a_animation_values : strings -> [> `Valuesanim ] attrib

  val a_keyTimes : strings -> [> `KeyTimes ] attrib

  val a_keySplines : strings -> [> `KeySplines ] attrib

  val a_from : uri -> [> `From ] attrib

  val a_to : uri -> [> `To ] attrib

  val a_by : uri -> [> `By ] attrib

  val a_additive : [< `Replace | `Sum ] -> [> `Additive ] attrib

  val a_accumulate : [< `None | `Sum ] -> [> `Accumulate ] attrib

  val a_keyPoints : numbers_semicolon -> [> `KeyPoints ] attrib

  val a_path : uri -> [> `Path ] attrib

  val a_animateTransform_type
    :  [ `Rotate | `Scale | `SkewX | `SkewY | `Translate ]
    -> [ `Typeanimatetransform ] attrib

  val a_horiz_origin_x : float -> [> `HorizOriginX ] attrib

  val a_horiz_origin_y : float -> [> `HorizOriginY ] attrib

  val a_horiz_adv_x : float -> [> `HorizAdvX ] attrib

  val a_vert_origin_x : float -> [> `VertOriginX ] attrib

  val a_vert_origin_y : float -> [> `VertOriginY ] attrib

  val a_vert_adv_y : float -> [> `VertAdvY ] attrib

  val a_unicode : uri -> [> `Unicode ] attrib

  val a_glyph_name : uri -> [> `glyphname ] attrib

  val a_orientation : [< `H | `V ] -> [> `Orientation ] attrib

  val a_arabic_form
    :  [< `Initial | `Isolated | `Medial | `Terminal ]
    -> [> `Arabicform ] attrib

  val a_lang : uri -> [> `Lang ] attrib

  val a_u1 : uri -> [> `U1 ] attrib

  val a_u2 : uri -> [> `U2 ] attrib

  val a_g1 : uri -> [> `G1 ] attrib

  val a_g2 : uri -> [> `G2 ] attrib

  val a_k : uri -> [> `K ] attrib

  val a_font_family : uri -> [> `Font_Family ] attrib

  val a_font_style : uri -> [> `Font_Style ] attrib

  val a_font_variant : uri -> [> `Font_Variant ] attrib

  val a_font_weight : uri -> [> `Font_Weight ] attrib

  val a_font_stretch : uri -> [> `Font_Stretch ] attrib

  val a_font_size : uri -> [> `Font_Size ] attrib

  val a_unicode_range : uri -> [> `UnicodeRange ] attrib

  val a_units_per_em : uri -> [> `UnitsPerEm ] attrib

  val a_stemv : float -> [> `Stemv ] attrib

  val a_stemh : float -> [> `Stemh ] attrib

  val a_slope : float -> [> `Slope ] attrib

  val a_cap_height : float -> [> `CapHeight ] attrib

  val a_x_height : float -> [> `XHeight ] attrib

  val a_accent_height : float -> [> `AccentHeight ] attrib

  val a_ascent : float -> [> `Ascent ] attrib

  val a_widths : uri -> [> `Widths ] attrib

  val a_bbox : uri -> [> `Bbox ] attrib

  val a_ideographic : float -> [> `Ideographic ] attrib

  val a_alphabetic : float -> [> `Alphabetic ] attrib

  val a_mathematical : float -> [> `Mathematical ] attrib

  val a_hanging : float -> [> `Hanging ] attrib

  val a_videographic : float -> [> `VIdeographic ] attrib

  val a_v_alphabetic : float -> [> `VAlphabetic ] attrib

  val a_v_mathematical : float -> [> `VMathematical ] attrib

  val a_v_hanging : float -> [> `VHanging ] attrib

  val a_underline_position : float -> [> `UnderlinePosition ] attrib

  val a_underline_thickness : float -> [> `UnderlineThickness ] attrib

  val a_strikethrough_position : float -> [> `StrikethroughPosition ] attrib

  val a_strikethrough_thickness : float -> [> `StrikethroughThickness ] attrib

  val a_overline_position : float -> [> `OverlinePosition ] attrib

  val a_overline_thickness : float -> [> `OverlineThickness ] attrib

  val a_string : uri -> [> `String ] attrib

  val a_name : uri -> [> `Name ] attrib

  val a_alignment_baseline
    :  [< `After_edge
       | `Alphabetic
       | `Auto
       | `Baseline
       | `Before_edge
       | `Central
       | `Hanging
       | `Ideographic
       | `Inherit
       | `Mathematical
       | `Middle
       | `Text_after_edge
       | `Text_before_edge
       ]
    -> [> `Alignment_Baseline ] attrib

  val a_dominant_baseline
    :  [< `Alphabetic
       | `Auto
       | `Central
       | `Hanging
       | `Ideographic
       | `Inherit
       | `Mathematical
       | `Middle
       | `No_change
       | `Reset_size
       | `Text_after_edge
       | `Text_before_edge
       | `Use_script
       ]
    -> [> `Dominant_Baseline ] attrib

  val a_stop_color : uri -> [> `Stop_Color ] attrib

  val a_stop_opacity : float -> [> `Stop_Opacity ] attrib

  val a_stroke : paint -> [> `Stroke ] attrib

  val a_stroke_width : Unit.length -> [> `Stroke_Width ] attrib

  val a_stroke_linecap
    :  [< `Butt | `Round | `Square ]
    -> [> `Stroke_Linecap ] attrib

  val a_stroke_linejoin
    :  [< `Bever | `Miter | `Round ]
    -> [> `Stroke_Linejoin ] attrib

  val a_stroke_miterlimit : float -> [> `Stroke_Miterlimit ] attrib

  val a_stroke_dasharray : Unit.length list -> [> `Stroke_Dasharray ] attrib

  val a_stroke_dashoffset : Unit.length -> [> `Stroke_Dashoffset ] attrib

  val a_stroke_opacity : float -> [> `Stroke_Opacity ] attrib

  val a_onabort : (Dom_html.event Js.t -> bool) -> [> `OnAbort ] attrib

  val a_onactivate : (Dom_html.event Js.t -> bool) -> [> `OnActivate ] attrib

  val a_onbegin : (Dom_html.event Js.t -> bool) -> [> `OnBegin ] attrib

  val a_onend : (Dom_html.event Js.t -> bool) -> [> `OnEnd ] attrib

  val a_onerror : (Dom_html.event Js.t -> bool) -> [> `OnError ] attrib

  val a_onfocusin : (Dom_html.event Js.t -> bool) -> [> `OnFocusIn ] attrib

  val a_onfocusout : (Dom_html.event Js.t -> bool) -> [> `OnFocusOut ] attrib

  val a_onrepeat : (Dom_html.event Js.t -> bool) -> [> `OnRepeat ] attrib

  val a_onresize : (Dom_html.event Js.t -> bool) -> [> `OnResize ] attrib

  val a_onscroll : (Dom_html.event Js.t -> bool) -> [> `OnScroll ] attrib

  val a_onunload : (Dom_html.event Js.t -> bool) -> [> `OnUnload ] attrib

  val a_onzoom : (Dom_html.event Js.t -> bool) -> [> `OnZoom ] attrib

  val a_onclick : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnClick ] attrib

  val a_onmousedown
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseDown ] attrib

  val a_onmouseup : (Dom_html.mouseEvent Js.t -> bool) -> [> `OnMouseUp ] attrib

  val a_onmouseover
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseOver ] attrib

  val a_onmouseout
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseOut ] attrib

  val a_onmousemove
    :  (Dom_html.mouseEvent Js.t -> bool)
    -> [> `OnMouseMove ] attrib

  val a_ontouchstart
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchStart ] attrib

  val a_ontouchend
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchEnd ] attrib

  val a_ontouchmove
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchMove ] attrib

  val a_ontouchcancel
    :  (Dom_html.touchEvent Js.t -> bool)
    -> [> `OnTouchCancel ] attrib

  val txt : uri -> [> txt ] elt
end

module Svg = Pure_svg
module Html = Pure_html
