# == Schema Information
#
# Table name: itps_documentations_tags
#
#  id               :integer          not null, primary key
#  documentation_id :integer          not null
#  tag_id           :integer          not null
#  count            :integer          default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Itps::DocumentationsTags < ActiveRecord::Base
  self.table_name = 'itps_documentations_tags'
  belongs_to :documentation,
    class_name: 'Itps::Documentation'
  belongs_to :tag,
    class_name: 'Itps::Tag'
  belongs_to :doc_tag,
    class_name: 'Itps::Tag',
    foreign_key: 'tag_id'
end
