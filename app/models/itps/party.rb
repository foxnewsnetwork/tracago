# == Schema Information
#
# Table name: itps_parties
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  email        :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  permalink    :string(255)      not null
#

class Itps::Party < ActiveRecord::Base
  self.table_name = 'itps_parties'
  has_many :bank_accounts,
    class_name: 'Itps::Parties::BankAccount'
  has_many :money_transfers,
    through: :bank_accounts,
    class_name: 'Itps::MoneyTransfer'
  has_one :main_bank_account,
    -> { ordered_by_defaulted_at.limit(1) },
    class_name: 'Itps::Parties::BankAccount'
  belongs_to :account,
    foreign_key: "email",
    primary_key: "email",
    class_name: 'Itps::Account'
  has_many :service_escrows,
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'
  has_many :payment_escrows,
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  has_many :active_service_escrows,
    -> { active },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'

  has_many :active_payment_escrows,
    -> { active },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  has_many :archived_service_escrows,
    -> { completed },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'
  alias_method :archive_service_escrows, :archived_service_escrows

  has_many :archived_payment_escrows,
    -> { completed },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'
  alias_method :archive_payment_escrows, :archived_payment_escrows

  has_many :in_progress_service_escrows,
    -> { inactive },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'
  alias_method :unready_service_escrows, :in_progress_service_escrows

  has_many :in_progress_payment_escrows,
    -> { inactive },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'
  alias_method :unready_payment_escrows, :in_progress_payment_escrows

  has_many :waiting_full_agreement_payment_escrows,
    -> { waiting_for_both_sides_to_agree },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'

  has_many :waiting_full_agreement_service_escrows,
    -> { waiting_for_both_sides_to_agree },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  validates :email,
    presence: true,
    format: { with: Devise.email_regexp }
  validates :company_name,
    :permalink,
    presence: true

  delegate :routing_number, 
    :account_number,
    to: :main_bank_account,
    allow_nil: true

  before_validation :_create_permalink

  class << self
    def find_by_permalink_or_id!(permalink_or_id)
      find_by_permalink(permalink_or_id) || find(permalink_or_id)
    end
  end

  def money_balance
    money_transfers.inject(0) do |balance, transfer|
      balance - transfer.dollar_amount_as_number
    end
  end

  def active_escrows(n=3)
    _limit_flatten_sort_merge n,
      active_payment_escrows, 
      active_service_escrows, 
      waiting_full_agreement_payment_escrows, 
      waiting_full_agreement_service_escrows
  end

  def in_progress_escrows(n=3)
    _limit_flatten_sort_merge n,
      in_progress_service_escrows, 
      in_progress_payment_escrows
  end

  def archived_escrows(n=3)
    _limit_flatten_sort_merge n,
      archived_service_escrows,
      archived_payment_escrows
  end

  def claimed?
    account.present?
  end

  def unclaimed?
    !claimed?
  end

  private
  def _limit_flatten_sort_merge(n, *es)
    (_limit_sort_merge n).call (_limit_flatten n).call es
  end

  def _limit_flatten(n)
    lambda do |ess|
      ess.map do |es|
        es.limit n
      end.flatten
    end
  end

  def _limit_sort_merge(n)
    lambda do |es|
      es.sort do |a,b|
        b.updated_at <=> a.updated_at
      end.take n
    end
  end

  def _create_permalink
    if permalink.blank? 
      self.permalink = "#{company_name.to_s.to_url}-#{rand 99999}-#{DateTime.now.to_i.to_alphabet}" 
    end
  end

end
