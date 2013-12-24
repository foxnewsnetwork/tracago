# == Schema Information
#
# Table name: spree_service_demands
#
#  id               :integer          not null, primary key
#  finalization_id  :integer
#  serviceable_id   :integer
#  serviceable_type :string(255)
#  fulfilled_at     :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

module Spree
  class ServiceDemand < ActiveRecord::Base
    belongs_to :finalization
    belongs_to :serviceable, polymorphic: true

    delegate :name,
      :summary,
      to: :serviceable

    scope :unfulfilled,
      -> { where "fulfilled_at is null" }

    class << self
      def latest_unfulfilled(n=5)
        unfulfilled.order("created_at desc").limit n
      end
    end

    def contract_with!(shop)
      update!(fulfilled_at: DateTime.now)
      Spree::ServiceContract.create! provider: shop,
        recipient: finalization,
        serviceable: serviceable
    end

  end
end
