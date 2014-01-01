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

class ChineseFactory::ServiceDemand < ChineseFactory::Base
  attr_accessor :finalization, :serviceable
  def belongs_to(thing)
    tap do |f|
      f.finalization = thing if thing.is_a? Spree::Finalization
      f.serviceable = thing if thing.is_a? Spree::Serviceable
    end
  end

  def initialize
    @finalization = ChineseFactory::Finalization.mock
    @serviceable = ChineseFactory::Serviceables.mock
  end

  def attributes
    {
      finalization: finalization,
      serviceable: serviceable
    }
  end
end
