# == Schema Information
#
# Table name: itps_drafts_items
#
#  id         :integer          not null, primary key
#  draft_id   :integer
#  name       :string(255)
#  unit       :string(255)
#  price      :decimal(16, 8)
#  quantity   :decimal(16, 8)
#  created_at :datetime
#  updated_at :datetime
#

class Itps::Drafts::Item < ActiveRecord::Base
  self.table_name = 'itps_drafts_items'
  belongs_to :draft,
    class_name: 'Itps::Draft'

  validates :name,
    :unit,
    :price,
    :quantity,
    :draft,
    presence: true
  validates :price,
    :quantity,
    numericality: true

  def total_cost
    return 0 if quantity.blank? || price.blank?
    quantity * price
  end
end
