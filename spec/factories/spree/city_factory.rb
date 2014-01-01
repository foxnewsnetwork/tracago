# == Schema Information
#
# Table name: spree_cities
#
#  id                 :integer          not null, primary key
#  state_id           :integer
#  romanized_name     :string(255)      not null
#  permalink          :string(255)      not null
#  local_presentation :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class ChineseFactory::City < ChineseFactory::Base
  attr_accessor :state
  def initialize
    @state = ChineseFactory::State.mock
  end

  def belongs_to(thing)
    tap do |f|
      f.state = thing if thing.is_a? Spree::State
    end
  end

  def attributes
    {
      romanized_name: Faker::AddressUS.city,
      local_presentation: Faker::AddressDE.city,
      state: state 
    }
  end
end
