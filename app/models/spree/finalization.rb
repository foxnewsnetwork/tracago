module Spree
  class Finalization < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :offer
    has_one :post_transaction,
      class_name: 'Spree::PostTransaction'
    has_many :service_demands
    has_many :service_contacts
    has_many :serviceables,
      through: :service_contacts

    delegate :destination,
      :origination,
      :buyer,
      :seller,
      to: :offer
    
    has_many :ratings, as: :reviewable    
    scope :fresh, 
      -> { where "#{self.table_name}.expires_at is null or #{self.table_name}.expires_at > ?", Time.now }

    def relevant_shops
      [offer.buyer, offer.seller]
    end

    def fresh?
      Time.now < _expiration_date
    end

    def shitty?
      post_transaction.present? && post_transaction.unresolved?
    end

    private

    def _expiration_date
      expires_at || 1000.years.from_now
    end
  end
end
