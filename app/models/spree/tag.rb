class Spree::Tag < ActiveRecord::Base
  KnownNames = [:front, :side, :back, :top, :closeup]
  class << self
    def standard_image_tags
      @standard_image_tags ||= KnownNames.map do |name|
        Spree::Tag.find_or_create_by presentation: name
      end
    end
  end
  has_many :visual_relationships,
    class_name: 'Spree::VisualRelationship'
  has_many :images,
    through: :visual_relationships,
    class_name: 'Spree::Image'
  before_validation :_enforce_permalink

  private

  def _enforce_permalink
    self.permalink = self.presentation.to_s.downcase
  end
end