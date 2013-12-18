class Itps::Escrow < ActiveRecord::Base
  has_many :steps,
    class_name: 'Itps::Escrows::Step'
  belongs_to :payment_party,
    class_name: 'Itps::Party'
  belongs_to :service_party,
    class_name: 'Itps::Party'

  before_validation :_create_permalink

  private
  def _create_permalink
    self.permalink ||= "#{DateTime.now.to_s}-#{payment_party.permalink}-#{service_party.permalink}"
  end
end