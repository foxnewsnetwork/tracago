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
