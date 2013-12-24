module ChineseFactory
  class State < Base
    class << self
      def mock
        belongs_to(Country.mock).create
      end

      def belongs_to(thing)
        new.belongs_to thing
      end
    end
    attr_accessor :country

    def belongs_to(thing)
      tap do |factory|
        factory.country = thing if thing.is_a? ::Spree::Country
      end
    end

    def attributes
      { 
        romanized_name: Faker::AddressUS.state,
        abbr: Faker::AddressUS.state_abbr,
        country: country
      }
    end

  end
end