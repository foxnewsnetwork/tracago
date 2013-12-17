class Itps::Documentation < ActiveRecord::Base
  self.table_name = 'itps_documentations'
  has_one :doc_tag,
    class_name: 'Itps::DocTag'
  before_validation :_create_permalink

  private
  def _create_permalink
    self.permalink = self.title.downcase.split('').select do |l| 
      l =~ /[a-z0-9\-_\s]/ 
    end.map do |l|
      l =~ /[\-_\s]/ ? '-' : l
    end.join
  end
end