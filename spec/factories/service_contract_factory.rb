class ChineseFactory::ServiceContract < ChineseFactory::Base
  attr_accessor :recipient, :provider, :serviceable
  def attributes
    {
      recipient: recipient,
      provider: provider,
      serviceable: serviceable
    }
  end

  def belongs_to(thing)
    tap do |f|
      f.recipient = thing if thing.is_a? Spree::Finalization
      f.provider = thing if thing.is_a? Spree::Shop
      f.serviceable = thing if thing.is_a? Spree::Serviceable
    end
  end

  def initialize
    @recipient = ChineseFactory::Finalization.mock
    @provider = ChineseFactory::Shop.mock
    @serviceable = ChineseFactory::Serviceables.mock
  end

end