class Itps::Escrow < ActiveRecord::Base
  acts_as_paranoid
  has_many :steps,
    class_name: 'Itps::Escrows::Step'
  has_one :last_step,
    -> { order("#{self.table_name}.position desc").limit(1) },
    class_name: 'Itps::Escrows::Step'
  belongs_to :payment_party,
    class_name: 'Itps::Party'
  belongs_to :service_party,
    class_name: 'Itps::Party'
  belongs_to :draft_party,
    class_name: 'Itps::Party'

  before_validation :_create_permalink
  validates :draft_party, 
    :payment_party, 
    :service_party, 
    presence: true

  def status
    return :deleted if deleted?
    return :closed if closed?
    return :opened if opened?
    return :unready
  end

  def drafted_by_payer?
    payment_party == draft_party
  end

  def drafted_by_worker?
    service_party == draft_party
  end

  def service_party_agree!
    update service_party_agreed_at: DateTime.now
  end

  def payment_party_agree!
    update payment_party_agreed_at: DateTime.now
  end

  def open!
    service_party_agree! && payment_party_agree!
  end

  def opened?
    service_party_agreed? && payment_party_agreed?
  end

  def other_party
    return payment_party if service_party == draft_party
    return service_party
  end

  def service_party_agreed?
    serviced_party_agreed_at.present?
  end

  def payment_party_agreed?
    payment_party_agreed_at.present?
  end

  def completed?
    completed_at.present?
  end
  alias_method :closed?, :completed?

  private
  def _create_permalink
    self.permalink ||= "#{DateTime.now.to_s}-#{payment_party.permalink}-#{service_party.permalink}"
  end
end