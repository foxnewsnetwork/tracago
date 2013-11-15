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