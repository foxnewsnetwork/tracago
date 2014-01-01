# == Schema Information
#
# Table name: spree_addresses
#
#  id                :integer          not null, primary key
#  fullname          :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  city_permalink    :string(255)
#  zipcode           :string(255)
#  phone             :string(255)
#  alternative_phone :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  nickname          :string(255)
#

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
