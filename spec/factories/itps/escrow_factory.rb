# == Schema Information
#
# Table name: itps_escrows
#
#  id                       :integer          not null, primary key
#  service_party_id         :integer          not null
#  payment_party_id         :integer          not null
#  draft_party_id           :integer          not null
#  permalink                :string(255)      not null
#  status_key               :string(255)
#  completed_at             :datetime
#  deleted_at               :datetime
#  payment_party_agreed_at  :datetime
#  serviced_party_agreed_at :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  payment_party_agree_key  :string(255)
#  service_party_agree_key  :string(255)
#  dollar_amount            :decimal(16, 2)
#

class JewFactory::Escrow < JewFactory::Base
  attr_accessor :attributes
  attr_hash_accessor :payment_party, :service_party, :draft_party
  def belongs_to(thing)
    tap do |f|
      f.draft_party = thing if thing.is_a? Itps::Party
      f.payment_party = thing if thing.is_a? Itps::Party
    end
  end

  def initialize
    self.payment_party = JewFactory::Party.mock
    self.draft_party = payment_party
    self.service_party = JewFactory::Party.mock
  end

end

module JewFactory::Escrows
  Dir[File.join(__dir__, "escrows", "*.rb")].each { |f| require f }
end
