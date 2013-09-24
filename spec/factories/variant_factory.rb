module ChineseFactory
  class Variant
    class << self
      def belongs_to(thing)
        new.belongs_to thing
      end

      def mock
        belongs_to(Address.mock).belongs_to(Product.mock).create
      end
    end
    attr_accessor :address, :product

    def belongs_to(thing)
      tap do |factory|
        factory.address = thing if thing.is_a? ::Spree::Address
        factory.product = thing if thing.is_a? ::Spree::Product
      end
    end

    def attributes
      {
        location: address,
        product: product,
        option_values: [],
        sku: "#{Faker::Company.bs}-#{rand 9999999}",
        cost_price: rand(234)
      }
    end

    def create
      ::Spree::Variant.create! attributes
    end
  end
end