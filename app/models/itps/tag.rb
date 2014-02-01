# == Schema Information
#
# Table name: itps_tags
#
#  id           :integer          not null, primary key
#  permalink    :string(255)      not null
#  presentation :string(255)      not null
#

class Itps::Tag < ActiveRecord::Base
  self.table_name = 'itps_tags'
  
  has_many :parent_to_child_relationships,
    class_name: 'Itps::TagsTags',
    foreign_key: 'parent_id'
  has_many :children,
    class_name: 'Itps::Tag',
    through: :parent_to_child_relationships
  
  has_one :child_to_parent_relationship,
    class_name: 'Itps::TagsTags',
    foreign_key: 'child_id'
  has_one :parent,
    class_name: 'Itps::Tag',
    through: :child_to_parent_relationship

  has_many :documentations_tags,
    class_name: 'Itps::DocumentationsTags'
  has_many :documentations,
    class_name: 'Itps::Documentation',
    through: :documentations_tags
  
  before_validation :_create_permalink

  validates :permalink,
    :presentation,
    presence: true
  validates :permalink, uniqueness: true

  class << self
    def root_presentations
      ['documentation','references','accessibility','faq','other'].freeze
    end

    def roots
      @roots ||= root_presentations.map do |presentation|
        find_or_create_by presentation: presentation
      end
    end

    def find_by_permalink_but_create_by_presentation(presentation)
      find_by_permalink(permalinkify presentation) || create!(presentation: presentation)
    end

    def permalinkify(presentation)
      presentation.downcase.split('').select do |l| 
        l =~ /[a-z0-9\-_\s]/ 
      end.map do |l|
        l =~ /[\-_\s]/ ? '-' : l
      end.join
    end
  end

  def title; presentation; end

  private
  def _create_permalink
    self.permalink = self.class.permalinkify presentation
  end
end
