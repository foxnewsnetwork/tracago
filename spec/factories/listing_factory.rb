module ChineseFactory
  class Listing
    class << self
      def belongs_to thing
        new.belongs_to thing
      end

      def mock
        belongs_to(Shop.mock).belongs_to(Stockpile.mock).belongs_to(Address.mock).create
      end
    end
    attr_accessor :shop, :stockpile, :address

    def belongs_to(thing)
      tap do |factory|
        factory.shop = thing if thing.is_a? ::Spree::Shop
        factory.stockpile = thing if thing.is_a? ::Spree::Stockpile
        factory.address = thing if thing.is_a? ::Spree::Address
      end
    end

    def create
      ::Spree::Listing.create! attributes
    end

    def attributes
      {
        shop: shop,
        stockpile: stockpile,
        address: address,
        days_to_refresh: rand(54),
        available_on: Time.now,
        expires_on: rand(423).days.from_now
      }
    end
  end
end