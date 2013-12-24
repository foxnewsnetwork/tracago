# == Schema Information
#
# Table name: spree_assets
#
#  id                      :integer          not null, primary key
#  viewable_id             :integer
#  viewable_type           :string(255)
#  attachment_width        :integer
#  attachment_height       :integer
#  attachment_file_size    :integer
#  position                :integer
#  attachment_content_type :string(255)
#  attachment_file_name    :string(255)
#  type                    :string(75)
#  attachment_updated_at   :datetime
#  alt                     :text
#

class Spree::Image < Spree::Asset
  self.table_name = 'spree_assets'
  validate :no_attachment_errors

  has_attached_file :attachment,
                    styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                    default_style: :product,
                    url: '/spree/products/:id/:style/:basename.:extension',
                    path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                    convert_options: { all: '-strip -auto-orient -colorspace RGB' }

  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet
  after_post_process :find_dimensions

  Spree::Image.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:attachment_styles]).symbolize_keys!
  Spree::Image.attachment_definitions[:attachment][:path] = Spree::Config[:attachment_path]
  Spree::Image.attachment_definitions[:attachment][:url] = Spree::Config[:attachment_url]
  Spree::Image.attachment_definitions[:attachment][:default_url] = Spree::Config[:attachment_default_url]
  Spree::Image.attachment_definitions[:attachment][:default_style] = Spree::Config[:attachment_default_style]

  has_many :visual_relationships,
    class_name: 'Spree::VisualRelationship'

  has_many :tags,
    through: :visual_relationships,
    class_name: 'Spree::Tag'

  def main_tag
    tags.first
  end

  def main_tag_name
    main_tag.permalink
  end

  def tag!(tag)
    visual_relationships.find_or_create_by! tag: tag
  end

  #used by admin products autocomplete
  def mini_url
    attachment.url(:mini, false)
  end

  def large_url
    attachment.url(:large)
  end

  def default_url
    attachment.url(:product)
  end

  def thumbnail_url
    attachment.url(:small)
  end

  def find_dimensions
    temporary = attachment.queued_for_write[:original]
    filename = temporary.path unless temporary.nil?
    filename = attachment.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.attachment_width  = geometry.width
    self.attachment_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def no_attachment_errors
    unless attachment.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear
      errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
      false
    end
  end
end
