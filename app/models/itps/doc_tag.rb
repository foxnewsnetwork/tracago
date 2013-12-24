# == Schema Information
#
# Table name: itps_doc_tags
#
#  id               :integer          not null, primary key
#  permalink        :string(255)      not null
#  title            :string(255)      not null
#  parent_id        :integer
#  documentation_id :integer
#  level            :integer          default(0), not null
#

class Itps::DocTag < ActiveRecord::Base
  self.table_name = 'itps_doc_tags'
  belongs_to :parent,
    class_name: 'Itps::DocTag'
  has_many :children,
    class_name: 'Itps::DocTag',
    foreign_key: 'parent_id'
  belongs_to :documentation,
    class_name: 'Itps::Documentation'
  before_validation :_create_permalink

  class << self
    def root_titles
      ['documentation','references','accessibility','faq','other']
    end

    def roots
      @roots ||= root_titles.map do |title|
        find_or_create_by title: title
      end
    end
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
