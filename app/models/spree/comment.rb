module Spree
  class Comment < ActiveRecord::Base
    acts_as_paranoid
    belongs_to :shop
    belongs_to :offer
  end
end
