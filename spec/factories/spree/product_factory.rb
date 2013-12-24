module ChineseFactory
  class Product
    attr_accessor :shop, :tax_category, :shipping_category

    def self.belongs_to(thing)
      new.belongs_to thing
    end

    def self.mock
      belongs_to(Shop.mock).belongs_to(TaxCategory.mock).belongs_to(ShippingCategory.mock).create
    end

    def belongs_to(thing)
      tap do |factory|
        factory.shop = thing if thing.is_a? ::Spree::Shop
        factory.tax_category = thing if thing.is_a? ::Spree::TaxCategory
        factory.shipping_category = thing if thing.is_a? ::Spree::ShippingCategory
      end
    end

    def attributes
      {
        name: Faker::Name.name,
        description: Faker::Lorem.paragraph,
        shop: shop,
        tax_category: tax_category,
        shipping_category: shipping_category,
        available_on: Time.zone.now,
        price: rand(321)
      }
    end

    def create
      ::Spree::Product.create! attributes
    end
  end
end