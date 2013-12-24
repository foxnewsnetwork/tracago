# == Schema Information
#
# Table name: spree_listings
#
#  id                    :integer          not null, primary key
#  stockpile_id          :integer          not null
#  shop_id               :integer
#  days_to_refresh       :integer
#  available_on          :datetime
#  expires_on            :datetime
#  deleted_at            :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  packing_weight_pounds :integer
#

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
    has_many :received_offers, 
      -> { completed },
      class_name: 'Spree::Offer'
    has_many :latest_offers,
      -> { completed.order 'created_at desc' },
      class_name: 'Spree::Offer'
    has_many :best_offers,
      -> { completed.order 'usd_per_pound desc' },
      class_name: 'Spree::Offer'
    has_many :dangerous_offers,
      -> { completed.order('expires_at asc') },
      class_name: 'Spree::Offer'
    has_many :images,
      through: :stockpile,
      class_name: 'Spree::Image'

    delegate :name,
      :default_image,
      :pounds_on_hand,
      :require_address?, 
      to: :stockpile

    def latest_best_and_most_dangerous_offers
      [latest_offers, best_offers, dangerous_offers].map do |offers|
        offers.first
      end.flatten.tap do |array|
        array[0].metadata = :latest
        array[1].metadata = :best
        array[2].metadata = :dangerous
      end
    end

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
