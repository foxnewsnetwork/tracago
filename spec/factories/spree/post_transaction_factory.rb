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

class ChineseFactory::PostTransaction < ChineseFactory::Base 
  attr_accessor :finalization

  def initialize
    @finalization = ChineseFactory::Finalization.mock
  end
  def belongs_to(thing)
    tap do |f|
      f.finalization = thing if thing.is_a? Spree::PostTransaction
    end
  end
  def attributes
    {}
  end
end
