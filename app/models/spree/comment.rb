module Spree
  class Comment < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop,
      class_name: 'Spree::Shop'
    belongs_to :offer,
      class_name: 'Spree::Offer'

    def by_buyer?
      shop == offer.buyer
    end

    def by_seller?
      shop == offer.seller
    end

    def subject
      I18n.t(:comment)
    end

  end
end
