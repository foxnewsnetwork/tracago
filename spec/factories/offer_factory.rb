module ChineseFactory
  class Offer
    attr_accessor :shop, :listing, :address
    class << self
      def belongs_to(thing)
        new.belongs_to thing
      end

      def mock
        new.mock
      end
    end

    def initialize
      @shop = Shop.mock
      @listing = Listing.mock
      @address = Address.mock
    end

    def belongs_to(thing)
      tap do |factory|
        factory.shop = thing if thing.is_a? ::Spree::Shop
        factory.listing = thing if thing.is_a? ::Spree::Listing
        factory.address = thing if thing.is_a? ::Spree::Address
      end
    end

    def create
      ::Spree::Offer.create! attributes
    end
    alias_method :mock, :create

    def attributes
      {
        shop: shop,
        address: address,
        listing: listing,
        usd_per_pound: rand(1234),
        shipping_terms: ::Spree::Offer::Terms.random,
        loads: rand(234)
      }
    end

  end
end