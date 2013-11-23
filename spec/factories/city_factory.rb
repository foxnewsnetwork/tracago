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