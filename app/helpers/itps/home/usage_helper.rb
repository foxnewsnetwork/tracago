module Itps::Home::UsageHelper
  def link_to_image_tag(pic)
    link_to image_tag(pic), image_path(pic)
  end
end