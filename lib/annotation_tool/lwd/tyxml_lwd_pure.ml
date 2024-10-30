open Tyxml_lwd

module Pure_html = struct
  include Html

  let a_class x = Html.a_class (Lwd.pure x)

  let a_user_data x y = Html.a_user_data x (Lwd.pure y)

  let a_id x = Html.a_id (Lwd.pure x)

  let a_title x = Html.a_title (Lwd.pure x)

  let a_xml_lang x = Html.a_xml_lang (Lwd.pure x)

  let a_lang x = Html.a_lang (Lwd.pure x)

  let a_onabort x = Html.a_onabort (Lwd.pure (Some x))

  let a_onafterprint x = Html.a_onafterprint (Lwd.pure (Some x))

  let a_onbeforeprint x = Html.a_onbeforeprint (Lwd.pure (Some x))

  let a_onbeforeunload x = Html.a_onbeforeunload (Lwd.pure (Some x))

  let a_onblur x = Html.a_onblur (Lwd.pure (Some x))

  let a_oncanplay x = Html.a_oncanplay (Lwd.pure (Some x))

  let a_oncanplaythrough x = Html.a_oncanplaythrough (Lwd.pure (Some x))

  let a_onchange x = Html.a_onchange (Lwd.pure (Some x))

  let a_ondurationchange x = Html.a_ondurationchange (Lwd.pure (Some x))

  let a_onemptied x = Html.a_onemptied (Lwd.pure (Some x))

  let a_onended x = Html.a_onended (Lwd.pure (Some x))

  let a_onerror x = Html.a_onerror (Lwd.pure (Some x))

  let a_onfocus x = Html.a_onfocus (Lwd.pure (Some x))

  let a_onformchange x = Html.a_onformchange (Lwd.pure (Some x))

  let a_onforminput x = Html.a_onforminput (Lwd.pure (Some x))

  let a_onhashchange x = Html.a_onhashchange (Lwd.pure (Some x))

  let a_oninput x = Html.a_oninput (Lwd.pure (Some x))

  let a_oninvalid x = Html.a_oninvalid (Lwd.pure (Some x))

  let a_onmousewheel x = Html.a_onmousewheel (Lwd.pure (Some x))

  let a_onoffline x = Html.a_onoffline (Lwd.pure (Some x))

  let a_ononline x = Html.a_ononline (Lwd.pure (Some x))

  let a_onpause x = Html.a_onpause (Lwd.pure (Some x))

  let a_onplay x = Html.a_onplay (Lwd.pure (Some x))

  let a_onplaying x = Html.a_onplaying (Lwd.pure (Some x))

  let a_onpagehide x = Html.a_onpagehide (Lwd.pure (Some x))

  let a_onpageshow x = Html.a_onpageshow (Lwd.pure (Some x))

  let a_onpopstate x = Html.a_onpopstate (Lwd.pure (Some x))

  let a_onprogress x = Html.a_onprogress (Lwd.pure (Some x))

  let a_onratechange x = Html.a_onratechange (Lwd.pure (Some x))

  let a_onreadystatechange x = Html.a_onreadystatechange (Lwd.pure (Some x))

  let a_onredo x = Html.a_onredo (Lwd.pure (Some x))

  let a_onresize x = Html.a_onresize (Lwd.pure (Some x))

  let a_onscroll x = Html.a_onscroll (Lwd.pure (Some x))

  let a_onseeked x = Html.a_onseeked (Lwd.pure (Some x))

  let a_onseeking x = Html.a_onseeking (Lwd.pure (Some x))

  let a_onselect x = Html.a_onselect (Lwd.pure (Some x))

  let a_onshow x = Html.a_onshow (Lwd.pure (Some x))

  let a_onstalled x = Html.a_onstalled (Lwd.pure (Some x))

  let a_onstorage x = Html.a_onstorage (Lwd.pure (Some x))

  let a_onsubmit x = Html.a_onsubmit (Lwd.pure (Some x))

  let a_onsuspend x = Html.a_onsuspend (Lwd.pure (Some x))

  let a_ontimeupdate x = Html.a_ontimeupdate (Lwd.pure (Some x))

  let a_onundo x = Html.a_onundo (Lwd.pure (Some x))

  let a_onunload x = Html.a_onunload (Lwd.pure (Some x))

  let a_onvolumechange x = Html.a_onvolumechange (Lwd.pure (Some x))

  let a_onwaiting x = Html.a_onwaiting (Lwd.pure (Some x))

  let a_onload x = Html.a_onload (Lwd.pure (Some x))

  let a_onloadeddata x = Html.a_onloadeddata (Lwd.pure (Some x))

  let a_onloadedmetadata x = Html.a_onloadedmetadata (Lwd.pure (Some x))

  let a_onloadstart x = Html.a_onloadstart (Lwd.pure (Some x))

  let a_onmessage x = Html.a_onmessage (Lwd.pure (Some x))

  let a_onclick x = Html.a_onclick (Lwd.pure (Some x))

  let a_oncontextmenu x = Html.a_oncontextmenu (Lwd.pure (Some x))

  let a_ondblclick x = Html.a_ondblclick (Lwd.pure (Some x))

  let a_ondrag x = Html.a_ondrag (Lwd.pure (Some x))

  let a_ondragend x = Html.a_ondragend (Lwd.pure (Some x))

  let a_ondragenter x = Html.a_ondragenter (Lwd.pure (Some x))

  let a_ondragleave x = Html.a_ondragleave (Lwd.pure (Some x))

  let a_ondragover x = Html.a_ondragover (Lwd.pure (Some x))

  let a_ondragstart x = Html.a_ondragstart (Lwd.pure (Some x))

  let a_ondrop x = Html.a_ondrop (Lwd.pure (Some x))

  let a_onmousedown x = Html.a_onmousedown (Lwd.pure (Some x))

  let a_onmouseup x = Html.a_onmouseup (Lwd.pure (Some x))

  let a_onmouseover x = Html.a_onmouseover (Lwd.pure (Some x))

  let a_onmousemove x = Html.a_onmousemove (Lwd.pure (Some x))

  let a_onmouseout x = Html.a_onmouseout (Lwd.pure (Some x))

  let a_ontouchstart x = Html.a_ontouchstart (Lwd.pure (Some x))

  let a_ontouchend x = Html.a_ontouchend (Lwd.pure (Some x))

  let a_ontouchmove x = Html.a_ontouchmove (Lwd.pure (Some x))

  let a_ontouchcancel x = Html.a_ontouchcancel (Lwd.pure (Some x))

  let a_onkeypress x = Html.a_onkeypress (Lwd.pure (Some x))

  let a_onkeydown x = Html.a_onkeydown (Lwd.pure (Some x))

  let a_onkeyup x = Html.a_onkeyup (Lwd.pure (Some x))

  let a_allowfullscreen = Html.a_allowfullscreen

  let a_allowpaymentrequest = Html.a_allowpaymentrequest

  let a_autocomplete x = Html.a_autocomplete (Lwd.pure x)

  let a_async = Html.a_async

  let a_autofocus = Html.a_autofocus

  let a_autoplay = Html.a_autoplay

  let a_muted = Html.a_muted

  let a_crossorigin x = Html.a_crossorigin (Lwd.pure x)

  let a_integrity x = Html.a_integrity (Lwd.pure x)

  let a_mediagroup x = Html.a_mediagroup (Lwd.pure x)

  let a_challenge x = Html.a_challenge (Lwd.pure x)

  let a_contenteditable x = Html.a_contenteditable (Lwd.pure x)

  let a_contextmenu x = Html.a_contextmenu (Lwd.pure x)

  let a_controls = Html.a_controls

  let a_dir x = Html.a_dir (Lwd.pure x)

  let a_draggable x = Html.a_draggable (Lwd.pure x)

  let a_form x = Html.a_form (Lwd.pure x)

  let a_formaction x = Html.a_formaction (Lwd.pure x)

  let a_formenctype x = Html.a_formenctype (Lwd.pure x)

  let a_formnovalidate = Html.a_formnovalidate

  let a_formtarget x = Html.a_formtarget (Lwd.pure x)

  let a_hidden = Html.a_hidden

  let a_high x = Html.a_high (Lwd.pure x)

  let a_icon x = Html.a_icon (Lwd.pure x)

  let a_ismap = Html.a_ismap

  let a_keytype x = Html.a_keytype (Lwd.pure x)

  let a_list x = Html.a_list (Lwd.pure x)

  let a_loop = Html.a_loop

  let a_low x = Html.a_low (Lwd.pure x)

  let a_max x = Html.a_max (Lwd.pure x)

  let a_input_max x = Html.a_input_max (Lwd.pure x)

  let a_min x = Html.a_min (Lwd.pure x)

  let a_input_min x = Html.a_input_min (Lwd.pure x)

  let a_inputmode x = Html.a_inputmode (Lwd.pure x)

  let a_novalidate = Html.a_novalidate

  let a_open = Html.a_open

  let a_optimum x = Html.a_optimum (Lwd.pure x)

  let a_pattern x = Html.a_pattern (Lwd.pure x)

  let a_placeholder x = Html.a_placeholder (Lwd.pure x)

  let a_poster x = Html.a_poster (Lwd.pure x)

  let a_preload x = Html.a_preload (Lwd.pure x)

  let a_pubdate = Html.a_pubdate

  let a_radiogroup x = Html.a_radiogroup (Lwd.pure x)

  let a_referrerpolicy x = Html.a_referrerpolicy (Lwd.pure x)

  let a_required = Html.a_required

  let a_reversed = Html.a_reversed

  let a_sandbox x = Html.a_sandbox (Lwd.pure x)

  let a_spellcheck x = Html.a_spellcheck (Lwd.pure x)

  let a_scoped = Html.a_scoped

  let a_seamless = Html.a_seamless

  let a_sizes x = Html.a_sizes (Lwd.pure x)

  let a_span x = Html.a_span (Lwd.pure x)

  let a_srcset x = Html.a_srcset (Lwd.pure x)

  let a_img_sizes x = Html.a_img_sizes (Lwd.pure x)

  let a_start x = Html.a_start (Lwd.pure x)

  let a_step x = Html.a_step (Lwd.pure x)

  let a_wrap x = Html.a_wrap (Lwd.pure x)

  let a_version x = Html.a_version (Lwd.pure x)

  let a_xmlns x = Html.a_xmlns (Lwd.pure x)

  let a_manifest x = Html.a_manifest (Lwd.pure x)

  let a_cite x = Html.a_cite (Lwd.pure x)

  let a_xml_space x = Html.a_xml_space (Lwd.pure x)

  let a_accesskey x = Html.a_accesskey (Lwd.pure x)

  let a_charset x = Html.a_charset (Lwd.pure x)

  let a_accept_charset x = Html.a_accept_charset (Lwd.pure x)

  let a_accept x = Html.a_accept (Lwd.pure x)

  let a_href x = Html.a_href (Lwd.pure x)

  let a_hreflang x = Html.a_hreflang (Lwd.pure x)

  let a_download x = Html.a_download (Lwd.pure x)

  let a_rel x = Html.a_rel (Lwd.pure x)

  let a_tabindex x = Html.a_tabindex (Lwd.pure x)

  let a_mime_type x = Html.a_mime_type (Lwd.pure x)

  let a_datetime x = Html.a_datetime (Lwd.pure x)

  let a_action x = Html.a_action (Lwd.pure x)

  let a_checked = Html.a_checked

  let a_cols x = Html.a_cols (Lwd.pure x)

  let a_enctype x = Html.a_enctype (Lwd.pure x)

  let a_label_for x = Html.a_label_for (Lwd.pure x)

  let a_output_for x = Html.a_output_for (Lwd.pure x)

  let a_maxlength x = Html.a_maxlength (Lwd.pure x)

  let a_minlength x = Html.a_minlength (Lwd.pure x)

  let a_method x = Html.a_method (Lwd.pure x)

  let a_multiple = Html.a_multiple

  let a_name x = Html.a_name (Lwd.pure x)

  let a_rows x = Html.a_rows (Lwd.pure x)

  let a_selected = Html.a_selected

  let a_size x = Html.a_size (Lwd.pure x)

  let a_src x = Html.a_src (Lwd.pure x)

  let a_input_type x = Html.a_input_type (Lwd.pure x)

  let a_text_value x = Html.a_text_value (Lwd.pure x)

  let a_int_value x = Html.a_int_value (Lwd.pure x)

  let a_value x = Html.a_value (Lwd.pure x)

  let a_float_value x = Html.a_float_value (Lwd.pure x)

  let a_disabled = Html.a_disabled

  let a_readonly = Html.a_readonly

  let a_button_type x = Html.a_button_type (Lwd.pure x)

  let a_command_type x = Html.a_command_type (Lwd.pure x)

  let a_menu_type x = Html.a_menu_type (Lwd.pure x)

  let a_label x = Html.a_label (Lwd.pure x)

  let a_colspan x = Html.a_colspan (Lwd.pure x)

  let a_headers x = Html.a_headers (Lwd.pure x)

  let a_rowspan x = Html.a_rowspan (Lwd.pure x)

  let a_alt x = Html.a_alt (Lwd.pure x)

  let a_height x = Html.a_height (Lwd.pure x)

  let a_width x = Html.a_width (Lwd.pure x)

  let a_shape x = Html.a_shape (Lwd.pure x)

  let a_coords x = Html.a_coords (Lwd.pure x)

  let a_usemap x = Html.a_usemap (Lwd.pure x)

  let a_data x = Html.a_data (Lwd.pure x)

  let a_scrolling x = Html.a_scrolling (Lwd.pure x)

  let a_target x = Html.a_target (Lwd.pure x)

  let a_content x = Html.a_content (Lwd.pure x)

  let a_http_equiv x = Html.a_http_equiv (Lwd.pure x)

  let a_defer = Html.a_defer

  let a_media x = Html.a_media (Lwd.pure x)

  let a_style x = Html.a_style (Lwd.pure x)

  let a_property x = Html.a_property (Lwd.pure x)

  let a_role x = Html.a_role (Lwd.pure x)

  let a_aria x y = Html.a_aria x (Lwd.pure y)

  let txt x = Html.txt (Lwd.pure x)

  let bdo ~dir = Html.bdo ~dir:(Lwd.pure dir)

  let img ~src ~alt = Html.img ~src:(Lwd.pure src) ~alt:(Lwd.pure alt)

  let audio ?src = Html.audio ?src:(Option.map Lwd.pure src)

  let video ?src = Html.video ?src:(Option.map Lwd.pure src)

  let area ~alt = Html.area ~alt:(Lwd.pure alt)

  let optgroup ~label = Html.optgroup ~label:(Lwd.pure label)

  let command ~label = Html.command ~label:(Lwd.pure label)

  let link ~rel ~href = Html.link ~rel:(Lwd.pure rel) ~href:(Lwd.pure href)
end

module Pure_svg = struct
  include Svg

  let a_x x = Svg.a_x (Lwd.pure x)

  let a_y x = Svg.a_y (Lwd.pure x)

  let a_width x = Svg.a_width (Lwd.pure x)

  let a_height x = Svg.a_height (Lwd.pure x)

  let a_preserveAspectRatio x = Svg.a_preserveAspectRatio (Lwd.pure x)

  let a_zoomAndPan x = Svg.a_zoomAndPan (Lwd.pure x)

  let a_href x = Svg.a_href (Lwd.pure x)

  let a_requiredExtensions x = Svg.a_requiredExtensions (Lwd.pure x)

  let a_systemLanguage x = Svg.a_systemLanguage (Lwd.pure x)

  let a_externalRessourcesRequired x =
    Svg.a_externalRessourcesRequired (Lwd.pure x)

  let a_id x = Svg.a_id (Lwd.pure x)

  let a_user_data x y = Svg.a_user_data x (Lwd.pure y)

  let a_xml_lang x = Svg.a_xml_lang (Lwd.pure x)

  let a_type x = Svg.a_type (Lwd.pure x)

  let a_media x = Svg.a_media (Lwd.pure x)

  let a_class x = Svg.a_class (Lwd.pure x)

  let a_style x = Svg.a_style (Lwd.pure x)

  let a_transform x = Svg.a_transform (Lwd.pure x)

  let a_viewBox x = Svg.a_viewBox (Lwd.pure x)

  let a_d x = Svg.a_d (Lwd.pure x)

  let a_pathLength x = Svg.a_pathLength (Lwd.pure x)

  let a_rx x = Svg.a_rx (Lwd.pure x)

  let a_ry x = Svg.a_ry (Lwd.pure x)

  let a_cx x = Svg.a_cx (Lwd.pure x)

  let a_cy x = Svg.a_cy (Lwd.pure x)

  let a_r x = Svg.a_r (Lwd.pure x)

  let a_x1 x = Svg.a_x1 (Lwd.pure x)

  let a_y1 x = Svg.a_y1 (Lwd.pure x)

  let a_x2 x = Svg.a_x2 (Lwd.pure x)

  let a_y2 x = Svg.a_y2 (Lwd.pure x)

  let a_points x = Svg.a_points (Lwd.pure x)

  let a_x_list x = Svg.a_x_list (Lwd.pure x)

  let a_y_list x = Svg.a_y_list (Lwd.pure x)

  let a_dx x = Svg.a_dx (Lwd.pure x)

  let a_dy x = Svg.a_dy (Lwd.pure x)

  let a_dx_list x = Svg.a_dx_list (Lwd.pure x)

  let a_dy_list x = Svg.a_dy_list (Lwd.pure x)

  let a_lengthAdjust x = Svg.a_lengthAdjust (Lwd.pure x)

  let a_textLength x = Svg.a_textLength (Lwd.pure x)

  let a_text_anchor x = Svg.a_text_anchor (Lwd.pure x)

  let a_text_decoration x = Svg.a_text_decoration (Lwd.pure x)

  let a_text_rendering x = Svg.a_text_rendering (Lwd.pure x)

  let a_rotate x = Svg.a_rotate (Lwd.pure x)

  let a_startOffset x = Svg.a_startOffset (Lwd.pure x)

  let a_method x = Svg.a_method (Lwd.pure x)

  let a_spacing x = Svg.a_spacing (Lwd.pure x)

  let a_glyphRef x = Svg.a_glyphRef (Lwd.pure x)

  let a_format x = Svg.a_format (Lwd.pure x)

  let a_markerUnits x = Svg.a_markerUnits (Lwd.pure x)

  let a_refX x = Svg.a_refX (Lwd.pure x)

  let a_refY x = Svg.a_refY (Lwd.pure x)

  let a_markerWidth x = Svg.a_markerWidth (Lwd.pure x)

  let a_markerHeight x = Svg.a_markerHeight (Lwd.pure x)

  let a_orient x = Svg.a_orient (Lwd.pure x)

  let a_local x = Svg.a_local (Lwd.pure x)

  let a_rendering_intent x = Svg.a_rendering_intent (Lwd.pure x)

  let a_gradientUnits x = Svg.a_gradientUnits (Lwd.pure x)

  let a_gradientTransform x = Svg.a_gradientTransform (Lwd.pure x)

  let a_spreadMethod x = Svg.a_spreadMethod (Lwd.pure x)

  let a_fx x = Svg.a_fx (Lwd.pure x)

  let a_fy x = Svg.a_fy (Lwd.pure x)

  let a_offset x = Svg.a_offset (Lwd.pure x)

  let a_patternUnits x = Svg.a_patternUnits (Lwd.pure x)

  let a_patternContentUnits x = Svg.a_patternContentUnits (Lwd.pure x)

  let a_patternTransform x = Svg.a_patternTransform (Lwd.pure x)

  let a_clipPathUnits x = Svg.a_clipPathUnits (Lwd.pure x)

  let a_maskUnits x = Svg.a_maskUnits (Lwd.pure x)

  let a_maskContentUnits x = Svg.a_maskContentUnits (Lwd.pure x)

  let a_primitiveUnits x = Svg.a_primitiveUnits (Lwd.pure x)

  let a_filterRes x = Svg.a_filterRes (Lwd.pure x)

  let a_result x = Svg.a_result (Lwd.pure x)

  let a_in x = Svg.a_in (Lwd.pure x)

  let a_in2 x = Svg.a_in2 (Lwd.pure x)

  let a_azimuth x = Svg.a_azimuth (Lwd.pure x)

  let a_elevation x = Svg.a_elevation (Lwd.pure x)

  let a_pointsAtX x = Svg.a_pointsAtX (Lwd.pure x)

  let a_pointsAtY x = Svg.a_pointsAtY (Lwd.pure x)

  let a_pointsAtZ x = Svg.a_pointsAtZ (Lwd.pure x)

  let a_specularExponent x = Svg.a_specularExponent (Lwd.pure x)

  let a_specularConstant x = Svg.a_specularConstant (Lwd.pure x)

  let a_limitingConeAngle x = Svg.a_limitingConeAngle (Lwd.pure x)

  let a_mode x = Svg.a_mode (Lwd.pure x)

  let a_feColorMatrix_type x = Svg.a_feColorMatrix_type (Lwd.pure x)

  let a_values x = Svg.a_values (Lwd.pure x)

  let a_transfer_type x = Svg.a_transfer_type (Lwd.pure x)

  let a_tableValues x = Svg.a_tableValues (Lwd.pure x)

  let a_intercept x = Svg.a_intercept (Lwd.pure x)

  let a_amplitude x = Svg.a_amplitude (Lwd.pure x)

  let a_exponent x = Svg.a_exponent (Lwd.pure x)

  let a_transfer_offset x = Svg.a_transfer_offset (Lwd.pure x)

  let a_feComposite_operator x = Svg.a_feComposite_operator (Lwd.pure x)

  let a_k1 x = Svg.a_k1 (Lwd.pure x)

  let a_k2 x = Svg.a_k2 (Lwd.pure x)

  let a_k3 x = Svg.a_k3 (Lwd.pure x)

  let a_k4 x = Svg.a_k4 (Lwd.pure x)

  let a_order x = Svg.a_order (Lwd.pure x)

  let a_kernelMatrix x = Svg.a_kernelMatrix (Lwd.pure x)

  let a_divisor x = Svg.a_divisor (Lwd.pure x)

  let a_bias x = Svg.a_bias (Lwd.pure x)

  let a_kernelUnitLength x = Svg.a_kernelUnitLength (Lwd.pure x)

  let a_targetX x = Svg.a_targetX (Lwd.pure x)

  let a_targetY x = Svg.a_targetY (Lwd.pure x)

  let a_edgeMode x = Svg.a_edgeMode (Lwd.pure x)

  let a_preserveAlpha x = Svg.a_preserveAlpha (Lwd.pure x)

  let a_surfaceScale x = Svg.a_surfaceScale (Lwd.pure x)

  let a_diffuseConstant x = Svg.a_diffuseConstant (Lwd.pure x)

  let a_scale x = Svg.a_scale (Lwd.pure x)

  let a_xChannelSelector x = Svg.a_xChannelSelector (Lwd.pure x)

  let a_yChannelSelector x = Svg.a_yChannelSelector (Lwd.pure x)

  let a_stdDeviation x = Svg.a_stdDeviation (Lwd.pure x)

  let a_feMorphology_operator x = Svg.a_feMorphology_operator (Lwd.pure x)

  let a_radius x = Svg.a_radius (Lwd.pure x)

  let a_baseFrenquency x = Svg.a_baseFrenquency (Lwd.pure x)

  let a_numOctaves x = Svg.a_numOctaves (Lwd.pure x)

  let a_seed x = Svg.a_seed (Lwd.pure x)

  let a_stitchTiles x = Svg.a_stitchTiles (Lwd.pure x)

  let a_feTurbulence_type x = Svg.a_feTurbulence_type (Lwd.pure x)

  let a_target x = Svg.a_target (Lwd.pure x)

  let a_attributeName x = Svg.a_attributeName (Lwd.pure x)

  let a_attributeType x = Svg.a_attributeType (Lwd.pure x)

  let a_begin x = Svg.a_begin (Lwd.pure x)

  let a_dur x = Svg.a_dur (Lwd.pure x)

  let a_min x = Svg.a_min (Lwd.pure x)

  let a_max x = Svg.a_max (Lwd.pure x)

  let a_restart x = Svg.a_restart (Lwd.pure x)

  let a_repeatCount x = Svg.a_repeatCount (Lwd.pure x)

  let a_repeatDur x = Svg.a_repeatDur (Lwd.pure x)

  let a_fill x = Svg.a_fill (Lwd.pure x)

  let a_animation_fill x = Svg.a_animation_fill (Lwd.pure x)

  let a_calcMode x = Svg.a_calcMode (Lwd.pure x)

  let a_animation_values x = Svg.a_animation_values (Lwd.pure x)

  let a_keyTimes x = Svg.a_keyTimes (Lwd.pure x)

  let a_keySplines x = Svg.a_keySplines (Lwd.pure x)

  let a_from x = Svg.a_from (Lwd.pure x)

  let a_to x = Svg.a_to (Lwd.pure x)

  let a_by x = Svg.a_by (Lwd.pure x)

  let a_additive x = Svg.a_additive (Lwd.pure x)

  let a_accumulate x = Svg.a_accumulate (Lwd.pure x)

  let a_keyPoints x = Svg.a_keyPoints (Lwd.pure x)

  let a_path x = Svg.a_path (Lwd.pure x)

  let a_animateTransform_type x = Svg.a_animateTransform_type (Lwd.pure x)

  let a_horiz_origin_x x = Svg.a_horiz_origin_x (Lwd.pure x)

  let a_horiz_origin_y x = Svg.a_horiz_origin_y (Lwd.pure x)

  let a_horiz_adv_x x = Svg.a_horiz_adv_x (Lwd.pure x)

  let a_vert_origin_x x = Svg.a_vert_origin_x (Lwd.pure x)

  let a_vert_origin_y x = Svg.a_vert_origin_y (Lwd.pure x)

  let a_vert_adv_y x = Svg.a_vert_adv_y (Lwd.pure x)

  let a_unicode x = Svg.a_unicode (Lwd.pure x)

  let a_glyph_name x = Svg.a_glyph_name (Lwd.pure x)

  let a_orientation x = Svg.a_orientation (Lwd.pure x)

  let a_arabic_form x = Svg.a_arabic_form (Lwd.pure x)

  let a_lang x = Svg.a_lang (Lwd.pure x)

  let a_u1 x = Svg.a_u1 (Lwd.pure x)

  let a_u2 x = Svg.a_u2 (Lwd.pure x)

  let a_g1 x = Svg.a_g1 (Lwd.pure x)

  let a_g2 x = Svg.a_g2 (Lwd.pure x)

  let a_k x = Svg.a_k (Lwd.pure x)

  let a_font_family x = Svg.a_font_family (Lwd.pure x)

  let a_font_style x = Svg.a_font_style (Lwd.pure x)

  let a_font_variant x = Svg.a_font_variant (Lwd.pure x)

  let a_font_weight x = Svg.a_font_weight (Lwd.pure x)

  let a_font_stretch x = Svg.a_font_stretch (Lwd.pure x)

  let a_font_size x = Svg.a_font_size (Lwd.pure x)

  let a_unicode_range x = Svg.a_unicode_range (Lwd.pure x)

  let a_units_per_em x = Svg.a_units_per_em (Lwd.pure x)

  let a_stemv x = Svg.a_stemv (Lwd.pure x)

  let a_stemh x = Svg.a_stemh (Lwd.pure x)

  let a_slope x = Svg.a_slope (Lwd.pure x)

  let a_cap_height x = Svg.a_cap_height (Lwd.pure x)

  let a_x_height x = Svg.a_x_height (Lwd.pure x)

  let a_accent_height x = Svg.a_accent_height (Lwd.pure x)

  let a_ascent x = Svg.a_ascent (Lwd.pure x)

  let a_widths x = Svg.a_widths (Lwd.pure x)

  let a_bbox x = Svg.a_bbox (Lwd.pure x)

  let a_ideographic x = Svg.a_ideographic (Lwd.pure x)

  let a_alphabetic x = Svg.a_alphabetic (Lwd.pure x)

  let a_mathematical x = Svg.a_mathematical (Lwd.pure x)

  let a_hanging x = Svg.a_hanging (Lwd.pure x)

  let a_videographic x = Svg.a_videographic (Lwd.pure x)

  let a_v_alphabetic x = Svg.a_v_alphabetic (Lwd.pure x)

  let a_v_mathematical x = Svg.a_v_mathematical (Lwd.pure x)

  let a_v_hanging x = Svg.a_v_hanging (Lwd.pure x)

  let a_underline_position x = Svg.a_underline_position (Lwd.pure x)

  let a_underline_thickness x = Svg.a_underline_thickness (Lwd.pure x)

  let a_strikethrough_position x = Svg.a_strikethrough_position (Lwd.pure x)

  let a_strikethrough_thickness x = Svg.a_strikethrough_thickness (Lwd.pure x)

  let a_overline_position x = Svg.a_overline_position (Lwd.pure x)

  let a_overline_thickness x = Svg.a_overline_thickness (Lwd.pure x)

  let a_string x = Svg.a_string (Lwd.pure x)

  let a_name x = Svg.a_name (Lwd.pure x)

  let a_alignment_baseline x = Svg.a_alignment_baseline (Lwd.pure x)

  let a_dominant_baseline x = Svg.a_dominant_baseline (Lwd.pure x)

  let a_stop_color x = Svg.a_stop_color (Lwd.pure x)

  let a_stop_opacity x = Svg.a_stop_opacity (Lwd.pure x)

  let a_stroke x = Svg.a_stroke (Lwd.pure x)

  let a_stroke_width x = Svg.a_stroke_width (Lwd.pure x)

  let a_stroke_linecap x = Svg.a_stroke_linecap (Lwd.pure x)

  let a_stroke_linejoin x = Svg.a_stroke_linejoin (Lwd.pure x)

  let a_stroke_miterlimit x = Svg.a_stroke_miterlimit (Lwd.pure x)

  let a_stroke_dasharray x = Svg.a_stroke_dasharray (Lwd.pure x)

  let a_stroke_dashoffset x = Svg.a_stroke_dashoffset (Lwd.pure x)

  let a_stroke_opacity x = Svg.a_stroke_opacity (Lwd.pure x)

  let a_onabort x = Svg.a_onabort (Lwd.pure (Some x))

  let a_onactivate x = Svg.a_onactivate (Lwd.pure (Some x))

  let a_onbegin x = Svg.a_onbegin (Lwd.pure (Some x))

  let a_onend x = Svg.a_onend (Lwd.pure (Some x))

  let a_onerror x = Svg.a_onerror (Lwd.pure (Some x))

  let a_onfocusin x = Svg.a_onfocusin (Lwd.pure (Some x))

  let a_onfocusout x = Svg.a_onfocusout (Lwd.pure (Some x))

  let a_onrepeat x = Svg.a_onrepeat (Lwd.pure (Some x))

  let a_onresize x = Svg.a_onresize (Lwd.pure (Some x))

  let a_onscroll x = Svg.a_onscroll (Lwd.pure (Some x))

  let a_onunload x = Svg.a_onunload (Lwd.pure (Some x))

  let a_onzoom x = Svg.a_onzoom (Lwd.pure (Some x))

  let a_onclick x = Svg.a_onclick (Lwd.pure (Some x))

  let a_onmousedown x = Svg.a_onmousedown (Lwd.pure (Some x))

  let a_onmouseup x = Svg.a_onmouseup (Lwd.pure (Some x))

  let a_onmouseover x = Svg.a_onmouseover (Lwd.pure (Some x))

  let a_onmouseout x = Svg.a_onmouseout (Lwd.pure (Some x))

  let a_onmousemove x = Svg.a_onmousemove (Lwd.pure (Some x))

  let a_ontouchstart x = Svg.a_ontouchstart (Lwd.pure (Some x))

  let a_ontouchend x = Svg.a_ontouchend (Lwd.pure (Some x))

  let a_ontouchmove x = Svg.a_ontouchmove (Lwd.pure (Some x))

  let a_ontouchcancel x = Svg.a_ontouchcancel (Lwd.pure (Some x))

  let txt x = Svg.txt (Lwd.pure x)
end

module Svg = Pure_svg
module Html = Pure_html
