module ChineseFactory
  class OptionValue
    class << self
      def belongs_to thing
        new.belongs_to thing
      end

      def mock
        new.create
      end
    end
    attr_accessor :option_type, :stockpile

    def initialize
      @option_type = OptionType.mock
      @stockpile = Stockpile.mock
    end

    def belongs_to(thing)
      tap do |factory|
        factory.option_type = thing if thing.is_a? ::Spree::OptionType
        factory.stockpile = thing if thing.is_a? ::Spree::Stockpile
      end
    end

    def attributes
      {
        position: rand(3434),
        name: Faker::Name.first_name,
        presentation: Faker::Name.first_name,
        option_type: option_type,
        stockpiles: [stockpile]
      }
    end

    def create
      ::Spree::OptionValue.create! attributes
    end
  end
end