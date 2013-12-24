# == Schema Information
#
# Table name: spree_ratings
#
#  id              :integer          not null, primary key
#  trustworthiness :integer          not null
#  simplicity      :integer          not null
#  agreeability    :integer          not null
#  notes           :text
#  shop_id         :integer
#  reviewer_id     :integer
#  reviewable_id   :integer
#  reviewable_type :string(255)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

module Spree
  class Rating < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop
    belongs_to :reviewed,
      class_name: 'Spree::Shop',
      foreign_key: 'shop_id'
    belongs_to :reviewer,
      class_name: 'Spree::Shop',
      foreign_key: 'reviewer_id'

    belongs_to :reviewable, polymorphic: true

    validates :trustworthiness, 
      :simplicity, 
      :agreeability,
      numericality: true,
      inclusion: { :in => 0..100 }

    class << self
      def max_possible_stars
        5
      end

      def max_possible_score
        100
      end
    end

    def score
      self.class.max_possible_score * average_percentage_credibility
    end

    def stars
      self.class.max_possible_stars * average_percentage_credibility
    end

    def average_percentage_credibility
      [trustworthiness, simplicity, agreeability].map(&:to_i).reduce(:+) / 300.0
    end
  end
end
