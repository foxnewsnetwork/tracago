# == Schema Information
#
# Table name: spree_finalizations
#
#  id         :integer          not null, primary key
#  offer_id   :integer
#  expires_at :datetime
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class ChineseFactory::Finalization < ChineseFactory::Base
  attr_accessor :offer
  def initialize
    @offer = ChineseFactory::Offer.mock
  end

  def attributes
    { 
      expires_at: (1 + rand(4324)).days.from_now,
      offer: offer
    }
  end

  def belongs_to(thing)
    tap do |factory|
      factory.offer = thing if thing.is_a? Spree::Offer
    end
  end


end
