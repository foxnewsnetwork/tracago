# == Schema Information
#
# Table name: spree_service_supplies
#
#  id               :integer          not null, primary key
#  shop_id          :integer
#  serviceable_id   :integer
#  serviceable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class ChineseFactory::ServiceSupply < ChineseFactory::Base
  attr_accessor :shop, :serviceable
  def belongs_to(thing)
    tap do |f|
      f.shop = thing if thing.is_a? Spree::Shop
      f.serviceable = thing if thing.is_a? Spree::Serviceable
    end
  end

  def initialize
    @shop = ChineseFactory::Shop.mock
    @serviceable = ChineseFactory::Serviceables.mock
  end

  def attributes
    {
      shop: shop,
      serviceable: serviceable
    }
  end
end
