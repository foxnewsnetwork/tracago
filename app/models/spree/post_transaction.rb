# == Schema Information
#
# Table name: spree_post_transactions
#
#  id              :integer          not null, primary key
#  finalization_id :integer
#  closed_at       :datetime
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

module Spree
  class PostTransaction < ActiveRecord::Base
    belongs_to :finalization
    has_many :rating, as: :reviewable

    delegate :relevant_shops, to: :finalization

    def close!
      update closed_at: Time.now
    end

    def shitty?
      closed_at.blank? || Time.now < closed_at
    end
    alias_method :unresolved?, :shitty?
  end
end
