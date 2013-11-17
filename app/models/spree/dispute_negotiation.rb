module Spree
  class DisputeNegotiation < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop
    belongs_to :post_transaction
  end
end
