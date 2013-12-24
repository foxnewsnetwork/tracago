# == Schema Information
#
# Table name: spree_tags_images
#
#  id       :integer          not null, primary key
#  tag_id   :integer
#  image_id :integer
#

class Spree::VisualRelationship < ActiveRecord::Base
  self.table_name = 'spree_tags_images'
  belongs_to :tag,
    class_name: 'Spree::Tag'
  belongs_to :image,
    class_name: 'Spree::Image'
end
