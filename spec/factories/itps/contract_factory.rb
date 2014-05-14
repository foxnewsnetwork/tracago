class JewFactory::Contract < JewFactory::Base
  attr_accessor :attributes
  attr_hash_accessor :draft

  def belongs_to(thing)
    tap do |f|
      f.draft = thing if thing.is_a? Itps::Draft
    end
  end

  def initialize
    self.draft = JewFactory::Draft.mock
  end

end