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
  IdBuffer = 23134
  acts_as_paranoid
  has_many :steps,
    class_name: 'Itps::Escrows::Step'
  belongs_to :payment_party,
    class_name: 'Itps::Party'
  belongs_to :service_party,
    class_name: 'Itps::Party'
  belongs_to :draft_party,
    class_name: 'Itps::Party'
  belongs_to :drafting_party,
    class_name: 'Itps::Party',
    foreign_key: 'draft_party_id'

  scope :incomplete,
    -> { where "#{self.table_name}.completed_at is null" }
  scope :completed,
    -> { where "#{self.table_name}.completed_at is not null" }
  scope :service_party_inactive,
    -> { where "#{self.table_name}.serviced_party_agreed_at is null" }
  scope :payment_party_inactive,
    -> { where "#{self.table_name}.payment_party_agreed_at is null" }
  scope :service_party_active,
    -> { where "#{self.table_name}.serviced_party_agreed_at is not null" }
  scope :payment_party_active,
    -> { where "#{self.table_name}.payment_party_agreed_at is not null" }
  scope :waiting_for_both_sides_to_agree,
    -> { incomplete.where("#{self.table_name}.serviced_party_agreed_at is null XOR #{self.table_name}.payment_party_agreed_at is null") }
  scope :edit_mode,
    -> { incomplete.service_party_inactive.payment_party_inactive }
  scope :inactive,
    -> { incomplete.service_party_inactive.payment_party_inactive }
  scope :active,
    -> { incomplete.payment_party_active.service_party_active }
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

  def last_step
    ordered_steps.last
  end

  def ordered_steps
    Itps::LinkListTools.sort_in_order steps
  end

  def full_presentation
    "Contract Id: #{IdBuffer + id.to_i}"
  end

  def relevant_accounts
    [service_party, payment_party, draft_party].map(&:account).reject(&:blank?)
  end

  def secret_key_for_account(account)
    return if account.blank? || account.party.blank?
    return payment_party_agree_key if payment_party == account.party
    return service_party_agree_key if service_party == account.party
  end

  def party_for_secret_key(key)
    return payment_party if payment_party_agree_key == key
    return service_party if service_party_agree_key == key
  end

  def secret_key_party_agree!(key)
    return false if key.blank?
    return payment_party if (payment_party_agree_key == key) && payment_party_agree!
    return service_party if (service_party_agree_key == key) && service_party_agree!
  end

  def secret_keys
    [payment_party_agree_key, service_party_agree_key].reject(&:blank?)
  end

  def unclaimed_secret_keys
    keys = []
    keys << payment_party_agree_key unless payment_party.claimed?
    keys << service_party_agree_key unless service_party.claimed?
    keys
  end

  def matches_payment_account?(account)
    return false if account.blank? || payment_party.blank?
    account == payment_party.account
  end

  def matches_service_account?(account)
    return false if account.blank? || service_party.blank?
    account == service_party.account
  end
  
  def edit_enabled?
    !locked?
  end

  def lockable?
    :edit_mode == status || :waiting_for_other_party == status
  end

  def status
    return :deleted if deleted?
    return :completed if completed?
    return :edit_mode if edit_mode?
    return :active if opened?
    return :waiting_for_other_party if single_side_locked?
    return :error
  end

  def edit_mode?
    !(completed? || locked?)
  end

  def payment_party_agreed_at_presentation
    payment_party_agreed_at.blank? ? I18n.t(:never) : payment_party_agreed_at.to_s(:long)
  end

  def service_party_agreed_at_presentation
    serviced_party_agreed_at.blank? ? I18n.t(:never) : serviced_party_agreed_at.to_s(:long)
  end

  def drafting_party_secret_key
    return payment_party_agree_key if drafted_by_payer?
    return service_party_agree_key if drafted_by_worker?
  end

  def drafted_by_payer?
    payment_party == draft_party
  end

  def drafted_by_worker?
    service_party == draft_party
  end

  def service_party_agree!
    update serviced_party_agreed_at: DateTime.now
  end

  def payment_party_agree!
    update payment_party_agreed_at: DateTime.now
  end

  def already_agreed_party
    return payment_party if payment_party_agreed?
    return service_party if service_party_agreed?
  end

  def not_agreed_party_secret_key
    return payment_party_agree_key if service_party_agreed?
    return service_party_agree_key if payment_party_agreed?
  end

  def other_party_agree!
    return payment_party_agree! if drafted_by_worker?
    return service_party_agree! if drafted_by_payer?
    raise ThirdPartyDraftingNotImplemeneted, "3rd party drafting needs implementation"
  end

  def open!
    service_party_agree! && payment_party_agree!
  end

  def single_side_locked?
    service_party_agreed? ^ payment_party_agreed?
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
    self.permalink ||= "#{DateTime.now.to_s}-#{payment_party.permalink}-#{service_party.permalink}".to_url
  end

  def _create_secret_hashes
    self.service_party_agree_key ||= Digest::SHA256.new.hexdigest( _create_permalink + "-service")
    self.payment_party_agree_key ||= Digest::SHA256.new.hexdigest( _create_permalink + "-payment")
  end
end
