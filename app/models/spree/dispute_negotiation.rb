# == Schema Information
#
# Table name: spree_dispute_negotiations
#
#  id                  :integer          not null, primary key
#  shop_id             :integer
#  post_transaction_id :integer
#  amount              :integer
#  comment             :text
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

module Spree
  class DisputeNegotiation < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop
    belongs_to :post_transaction
  end
end
