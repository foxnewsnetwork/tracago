module ChineseFactory
  class Country
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        romanized_name: Faker::Address.country,
        iso: Faker::AddressUS.state_abbr,
        iso3: Faker::Address.country.slice(0,3).upcase,
        numcode: rand(234)
      }
    end

    def create
      ::Spree::Country.create! attributes
    end
  end
end