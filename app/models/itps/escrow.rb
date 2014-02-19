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
#  claimed_at               :datetime
#

class Itps::Escrow < ActiveRecord::Base
  class ThirdPartyDraftingNotImplemeneted < ::StandardError; end
  IdBuffer = 193939
  acts_as_paranoid
  has_many :steps,
    class_name: 'Itps::Escrows::Step'
  has_many :money_transfers_escrows,
    class_name: 'Itps::MoneyTransfersEscrows',
    dependent: :destroy
  has_many :money_transfers,
    -> { inbound },
    through: :money_transfers_escrows,
    class_name: 'Itps::MoneyTransfer'
  has_many :outbound_money_transfers,
    -> { outbound },
    through: :money_transfers_escrows,
    class_name: 'Itps::MoneyTransfer'
  belongs_to :payment_party,
    class_name: 'Itps::Party'
  belongs_to :service_party,
    class_name: 'Itps::Party'
  belongs_to :draft_party,
    class_name: 'Itps::Party'
  belongs_to :drafting_party,
    class_name: 'Itps::Party',
    foreign_key: 'draft_party_id'

  scope :order_by_latest,
    -> { order "#{self.table_name}.updated_at desc" }
  scope :unclaimed,
    -> { incomplete.where "#{self.table_name}.claimed_at is null" }
  scope :claimed,
    -> { incomplete.where "#{self.table_name}.claimed_at is not null" }
  scope :incomplete,
    -> { where "#{self.table_name}.completed_at is null" }
  scope :completed,
    -> { where "#{self.table_name}.completed_at is not null" }
  scope :archived,
    -> { completed }
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
  validates :dollar_amount,
    numericality: true

  class << self
    def find_by_mysteriously_encryped_key!(mysterious_key: '', work: false)
      return find_by_service_party_agree_key! mysterious_key if work.present?
      return find_by_payment_party_agree_key! mysterious_key
    end

    def exist_by_bullshit_id?(id)
      find_by_bullshit_id(id).present?
    end

    def find_by_bullshit_id(id)
      find_by_id unbullshitify_id id
    end

    def bullshitify_id(id)
      IdBuffer + id.to_i * 7
    end

    def unbullshitify_id(bullshit_id)
      (bullshit_id.to_i - IdBuffer) / 7
    end
  end

  def copy_steps_from!(escrow)
    escrow.steps.map do |step|
      steps.create! title: step.title,
        instructions: step.instructions,
        position: step.position,
        class_name: step.class_name
    end
  end

  def attempt_destroy!
    return true if edit_mode? && destroy
    false
  end

  def last_step
    ordered_steps.last
  end

  def ordered_steps
    Itps::LinkListTools.sort_in_order steps
  end

  def full_presentation
    "Contract Id: #{self.class.bullshitify_id id}"
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

  def account_party_agree!(account)
    return false if account.blank?
    return payment_party if payment_party == account.party && payment_party_agree!
    return service_party if service_party == account.party && service_party_agree!
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

  def claimed?
    money_transfers.present?
  end

  def unclaimed?
    money_transfers.empty?
  end

  def fully_funded?
    funded_amount == dollar_amount
  end

  def funding_difference
    return if funded_amount.blank? || dollar_amount.blank?
    funded_amount - dollar_amount
  end

  def funded_amount
    return if money_transfers.blank?
    money_transfers.reduce(-Itps::MoneyTransfer::Fees) { |money, transfer| money + transfer.dollar_amount }
  end

  def funded_at
    money_transfers.last.try(:updated_at)
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

  def funding_status
    return :not_funded if money_transfers.blank?
    return :underfunded if funded_amount < dollar_amount
    return :overfunded if funded_amount > dollar_amount 
    return :fully_funded if funded_amount == dollar_amount
    return :error
  end

  def status
    return :deleted if deleted?
    return :completed if completed?
    return :edit_mode if edit_mode?
    return :active if opened?
    return :waiting_for_other_party if single_side_locked?
    return :error
  end

  def expired_or_archived?
    deleted? || completed?
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
  alias_method :service_party_agrees!, :service_party_agree!

  def payment_party_agree!
    update payment_party_agreed_at: DateTime.now
  end
  alias_method :payment_party_agrees!, :payment_party_agree!

  def already_agreed_parties
    Array.new.tap do |ps|
      ps << payment_party if payment_party_agreed?
      ps << service_party if service_party_agreed?
    end
  end

  def already_agreed?(party)
    return true if party == payment_party && payment_party_agreed?
    return true if party == service_party && service_party_agreed?
    false
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
  alias_method :archived?, :completed?

  private
  def _create_permalink
    self.permalink ||= "#{DateTime.now.to_i.to_alphabet}-#{payment_party.permalink}-#{rand(999999).to_alphabet}".to_url
  end

  def _create_secret_hashes
    self.service_party_agree_key ||= Digest::MD5.new.hexdigest( _create_permalink + "-service")
    self.payment_party_agree_key ||= Digest::MD5.new.hexdigest( _create_permalink + "-payment")
  end
end
