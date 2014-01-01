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

class ChineseFactory::Serviceables::Truck < ChineseFactory::Base
  def attributes
    p = (1 + rand(234))
    {
      origination: ChineseFactory::Address.mock,
      destination: ChineseFactory::Address.mock,
      pickup_at: p.days.from_now,
      arrive_at: (p + 1).days.from_now,
      usd_price: rand(44442)
    }
  end
end
