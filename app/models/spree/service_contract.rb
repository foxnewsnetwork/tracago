module Spree
  class ServiceContract < ActiveRecord::Base
    belongs_to :recipient,
      foreign_key: 'finalization_id',
      class_name: 'Spree::Finalization'

    belongs_to :provider,
      foreign_key: 'shop_id',
      class_name: 'Spree::Shop'

    belongs_to :serviceable, polymorphic: true
  end
end
