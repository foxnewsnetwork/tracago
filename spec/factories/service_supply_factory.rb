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