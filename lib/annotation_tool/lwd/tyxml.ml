module Xml = Tyxml_lwd.Xml

module Svg = struct
  include Tyxml_lwd_pure.Svg

  let class_ x = a_class [ x ]
end

module Html = struct
  include Tyxml_lwd_pure.Html

  let class_ x = a_class [ x ]
end
