module ChineseFactory
  class Address

    def self.belongs_to(thing)
      new.belongs_to(thing)
    end

    def self.mock
      new.create
    end

    def self.attributes
      new.attributes
    end

    attr_accessor :city

    def initialize
      @city = City.mock
    end

    def belongs_to(thing)
      tap do |factory|
        factory.city = thing if thing.is_a? ::Spree::City
      end
    end

    def attributes
      {
        fullname: Faker::Name.name,
        address1: Faker::Address.street_address,
        address2: Faker::Address.secondary_address,
        city: city,
        zipcode: Faker::AddressUS.zip_code,
        phone: Faker::PhoneNumber.phone_number
      }
    end

    def create
      ::Spree::Address.create! attributes
    end
  end
end
