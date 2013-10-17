module ChineseFactory
  class Listing
    class << self
      def belongs_to thing
        new.belongs_to thing
      end

      def mock
        new.create
      end
    end
    attr_accessor :shop, :stockpile, :address

    def initialize
      @shop = Shop.mock
      @stockpile = Stockpile.mock
      @address = Address.mock
    end

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
    alias_method :mock, :create

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