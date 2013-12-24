module ChineseFactory
  class OptionType
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        name: Faker::Name.first_name,
        presentation: Faker::Name.first_name,
        position: rand(344) 
      }
    end

    def create
      ::Spree::OptionType.create attributes
    end
  end
end
