# == Schema Information
#
# Table name: itps_documentations
#
#  id         :integer          not null, primary key
#  permalink  :string(255)      not null
#  title      :string(255)      not null
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Itps::Documentation < ActiveRecord::Base
  self.table_name = 'itps_documentations'
  has_many :documentations_tags,
    class_name: 'Itps::DocumentationsTags'
  has_many :tags,
    through: :documentations_tags,
    class_name: 'Itps::Tag'
  has_many :doc_tags,
    through: :documentations_tags,
    class_name: 'Itps::Tag'
  before_validation :_create_permalink

  # Obviously not thread safe or concurrent, but since I'm the only person who is EVER
  # going to be writing documentation, I fail to care since I literally can't race-condition
  # against myself
  def tag!(*presentations)
    presentations.map do |presentation|
      Itps::Tag.find_by_permalink_but_create_by_presentation presentation
    end.map do |tag|
      documentations_tags.find_or_create_by tag_id: tag.id
    end.map do |relationship|
      relationship.update count: relationship.count + 1
    end
  end

  def presentation; title; end
  def active_tag
    tags.first
  end

  def html_body
    @html_body ||= Kramdown::Document.new(body).to_html
  end

  private
  def _create_permalink
    self.permalink = self.title.downcase.split('').select do |l| 
      l =~ /[a-z0-9\-_\s]/ 
    end.map do |l|
      l =~ /[\-_\s]/ ? '-' : l
    end.join
  end
end
