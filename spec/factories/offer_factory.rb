module ChineseFactory
  class Offer
    attr_accessor :user, :listing, :address
    class << self
      def belongs_to(thing)
        new.belongs_to thing
      end

      def mock
        belongs_to(Address.mock).belongs_to(User.mock).belongs_to(Listing.mock).create
      end
    end

    def belongs_to(thing)
      tap do |factory|
        factory.user = thing if thing.is_a? ::Spree::User
        factory.listing = thing if thing.is_a? ::Spree::Listing
        factory.address = thing if thing.is_a? ::Spree::Address
      end
    end

    def create
      ::Spree::Offer.create! attributes
    end

    def attributes
      {
        user: user,
        address: address,
        listing: listing,
        usd_per_pound: rand(1234),
        shipping_terms: ::Spree::Offer::Terms.random,
        containers: rand(234)
      }
    end

  end
end