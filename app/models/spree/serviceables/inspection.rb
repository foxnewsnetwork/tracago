# == Schema Information
#
# Table name: spree_serviceables_inspections
#
#  id           :integer          not null, primary key
#  inspected_at :datetime
#  usd_price    :integer
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Spree::Serviceables::Inspection < Spree::Serviceable
  self.table_name = 'spree_serviceables_inspections'

  has_many :images,
    as: :viewable,
    dependent: :destroy,
    class_name: 'Spree::Image'
end
