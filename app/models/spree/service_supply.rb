module Spree
  class ServiceSupply < ActiveRecord::Base
    belongs_to :shop
    belongs_to :serviceable

    def contract_with!(finalization)
      Spree::ServiceContract.create! provider: shop,
        recipient: finalization,
        serviceable: serviceable
    end
  end
end
