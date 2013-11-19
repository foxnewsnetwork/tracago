module Spree
  class ServiceSupply < ActiveRecord::Base
    belongs_to :shop
    belongs_to :serviceable, polymorphic: true

    delegate :name,
      :summary,
      to: :serviceable

    class << self
      def latest(n=5)
        order("created_at desc").limit n
      end
    end

    def contract_with!(finalization)
      Spree::ServiceContract.create! provider: shop,
        recipient: finalization,
        serviceable: serviceable
    end
  end
end
