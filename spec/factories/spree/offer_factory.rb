# == Schema Information
#
# Table name: spree_offers
#
#  id                      :integer          not null, primary key
#  shop_id                 :integer
#  listing_id              :integer
#  address_id              :integer
#  usd_per_pound           :decimal(10, 5)   default(0.0), not null
#  loads                   :integer
#  shipping_terms          :string(255)      default("EXWORKS"), not null
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  expires_at              :datetime
#  transport_method        :string(255)      default("CONTAINER"), not null
#  minimum_pounds_per_load :integer
#  confirmed_at            :datetime
#

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
        usd_per_pound: rand(1234) + 1,
        shipping_terms: ::Spree::Offer::Terms.random,
        loads: rand(234) + 1
      }
    end

  end
end
