module ChineseFactory
  class State
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
        name: Faker::Address.state,
        abbr: Faker::Address.state_abbr,
        country: country
      }
    end

    def create
      ::Spree::State.create! attributes
    end
  end
end