# == Schema Information
#
# Table name: itps_tags_tags
#
#  id         :integer          not null, primary key
#  parent_id  :integer          not null
#  child_id   :integer          not null
#  count      :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class Itps::TagsTags < ActiveRecord::Base
  self.table_name = 'itps_tags_tags'
  belongs_to :parent,
    class_name: 'Itps::Tag'
  belongs_to :child,
    class_name: 'Itps::Tag'
end
