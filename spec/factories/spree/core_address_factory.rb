class ChineseFactory::CoreAddress < ChineseFactory::Base
  attr_accessor :state, :country, :locatable

  def initialize
    @state = ChineseFactory::State.mock
    @country = ChineseFactory::Country.mock
    @locatable = ChineseFactory::Locatable.mock
  end

  def attributes
    {
      fullname: Faker::Name.name,
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: state,
      zipcode: Faker::AddressUS.zip_code,
      country: country,
      locatable: locatable
    }
  end
end