class ChineseFactory::ServiceDemand < ChineseFactory::Base
  attr_accessor :finalization, :serviceable
  def belongs_to(thing)
    tap do |f|
      f.finalization = thing if thing.is_a? Spree::Finalization
      f.serviceable = thing if thing.is_a? Spree::Serviceable
    end
  end

  def initialize
    @finalization = ChineseFactory::Finalization.mock
    @serviceable = ChineseFactory::Serviceables.mock
  end

  def attributes
    {
      finalization: finalization,
      serviceable: serviceable
    }
  end
end