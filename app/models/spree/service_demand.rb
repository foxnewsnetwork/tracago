module Spree
  class ServiceDemand < ActiveRecord::Base
    belongs_to :finalization
    belongs_to :serviceable

    def contract_with!(shop)
      Spree::ServiceContract.create! provider: shop,
        recipient: finalization,
        serviceable: serviceable
    end
  end
end
