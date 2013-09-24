module ChineseFactory
  class Address

    def self.belongs_to(thing)
      new.belongs_to(thing)
    end

    def self.mock
      belongs_to(Country.mock).belongs_to(State.mock).create
    end

    attr_accessor :state, :country

    def belongs_to(thing)
      tap do |factory|
        factory.state = thing if thing.is_a? ::Spree::State
        factory.country = thing if thing.is_a? ::Spree::Country
      end
    end

    def attributes
      {
        firstname: Faker::Name.first_name,
        lastname: Faker::Name.last_name,
        nickname: Faker::Name.name,
        :address1 => Faker::Address.street_address,
        :address2 => Faker::Address.secondary_address,
        :city => Faker::Address.city,
        :state => state,
        :zipcode => Faker::Address.zip,
        :country => country,
        :phone => Faker::PhoneNumber.phone_number
      }
    end

    def create
      ::Spree::Address.create! attributes
    end
  end
end
