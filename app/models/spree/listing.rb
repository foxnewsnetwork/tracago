module Spree
  class Listing < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop, 
      class_name: 'Spree::Shop'
    belongs_to :stockpile, 
      class_name: 'Spree::Stockpile'
    has_one :address,
      through: :stockpile,
      class_name: 'Spree::Address'
    has_one :origination,
      through: :stockpile,
      class_name: 'Spree::Address'
    has_many :offers, 
      -> { completed },
      class_name: 'Spree::Offer'
    has_many :images,
      through: :stockpile,
      class_name: 'Spree::Image'

    delegate :name,
      :pounds_on_hand,
      :require_address?, 
      to: :stockpile

    def latest_offer
      offers.order("created_at desc").first
    end

    def owner
      shop.user
    end

    def minimum_weight
      packing_weight_pounds
    end

    def seller_offer
      offers.where(id: shop.user_id).first
    end

    def latest_offers(n=5)
      offers.sort do |b,a|
        a.created_at <=> b.created_at
      end.take 5
    end

    def max_offer
      offers.sort do |a,b|
        a.total_usd <=> b.total_usd
      end.last
    end

    def require_shop?
      shop.blank?
    end

    def require_stockpile?
      stockpile.blank?
    end

    def complete?
      !incomplete?
    end

    def incomplete?
      require_stockpile? || require_shop? || require_address?
    end

  end
end
