# == Schema Information
#
# Table name: spree_serviceables_trucks
#
#  id             :integer          not null, primary key
#  origination_id :integer
#  destination_id :integer
#  pickup_at      :datetime
#  arrive_at      :datetime
#  usd_price      :decimal(10, 2)
#  created_at     :datetime
#  updated_at     :datetime
#

class Spree::Serviceables::Truck < Spree::Serviceable
  self.table_name = 'spree_serviceables_trucks'

  belongs_to :origination,
    class_name: 'Spree::Address'

  belongs_to :destination,
    class_name: 'Spree::Address'

  def summary
    "#{origination.permalink_name} to #{destination.permalink_name}"
  end
end
