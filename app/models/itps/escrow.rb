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
#

class Itps::Escrow < ActiveRecord::Base
  class ThirdPartyDraftingNotImplemeneted < ::StandardError; end
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

  before_validation :_create_permalink, :_create_secret_hashes
  validates :draft_party, 
    :payment_party, 
    :service_party, 
    presence: true

  class << self
    def find_by_mysteriously_encryped_key!(mysterious_key: '', work: false)
      return find_by_service_party_agree_key! mysterious_key if work.present?
      return find_by_payment_party_agree_key! mysterious_key
    end
  end
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

  def other_party_agree!
    return payment_party_agree! if drafted_by_worker?
    return service_party_agree! if drafted_by_payer?
    raise ThirdPartyDraftingNotImplemeneted, "3rd party drafting needs implementation"
  end

  def open!
    service_party_agree! && payment_party_agree!
  end

  def locked?
    service_party_agreed? || payment_party_agreed?
  end

  def opened?
    service_party_agreed? && payment_party_agreed?
  end

  def other_party
    return payment_party if service_party == draft_party
    return service_party
  end

  def other_party_agree_key
    return payment_party_agree_key if service_party == draft_party
    return service_party_agree_key
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

  def _create_secret_hashes
    self.service_party_agree_key ||= Digest::SHA256.new.hexdigest( _create_permalink + "-service")
    self.payment_party_agree_key ||= Digest::SHA256.new.hexdigest( _create_permalink + "-payment")
  end
end
