class JewFactory::Escrow < JewFactory::Base
  attr_accessor :attributes
  attr_hash_accessor :payment_party, :service_party, :draft_party
  def belongs_to(thing)
    tap do |f|
      f.draft_party = thing if thing.is_a? Itps::Party
    end
  end

  def initialize
    self.payment_party = JewFactory::Party.mock
    self.draft_party = payment_party
    self.service_party = JewFactory::Party.mock
  end

end