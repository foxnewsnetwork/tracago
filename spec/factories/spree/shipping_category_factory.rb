module ChineseFactory
  class ShippingCategory
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        name: "Shipping via #{Faker::Company.name}"
      }
    end

    def create
      Spree::ShippingCategory.create! attributes
    end
  end
end