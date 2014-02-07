# == Schema Information
#
# Table name: itps_money_transfers
#
#  id              :integer          not null, primary key
#  bank_account_id :integer
#  dollar_amount   :decimal(16, 2)
#  inbound         :boolean          default(TRUE), not null
#  memo            :string(255)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  bank_name       :string(255)
#  name_on_account :string(255)
#  claimed_at      :datetime
#

class Itps::MoneyTransfer < ActiveRecord::Base
  Fees = 80
  acts_as_paranoid
  self.table_name = 'itps_money_transfers'
  belongs_to :bank_account,
    class_name: 'Itps::Parties::BankAccount'
  has_many :money_transfers_escrows,
    class_name: 'Itps::MoneyTransfersEscrows',
    dependent: :destroy
  has_many :escrows,
    through: :money_transfers_escrows,
    class_name: 'Itps::Escrow'
  alias_method :relationships, :money_transfers_escrows

  delegate :routing_number,
    :account_number,
    to: :bank_account
  scope :inbound,
    -> { where "#{self.table_name}.inbound is true" }
  scope :outbound,
    -> { where "#{self.table_name}.inbound is false"}
  scope :unclaimed,
    -> { where("#{self.table_name}.claimed_at is null") }
  scope :claimed,
    -> { where("#{self.table_name}.claimed_at is not null" ) }
  
  class << self
    # Probably cache this value somewhere
    def bank_balance
      _calculate_some_sort_of_balance all
    end

    def unclaimed_balance
      _calculate_some_sort_of_balance unclaimed
    end

    def claimed_balance
      _calculate_some_sort_of_balance claimed
    end

    private
    def _calculate_some_sort_of_balance(transfers)
      transfers.reduce(0) do |cumsum, transfer|
        cumsum + transfer.dollar_amount_as_number
      end
    end
  end

  def attempt_destroy
    destroy
  end

  def relationship_with(escrow)
    relationships.find_by_escrow_id escrow.id
  end

  def unclaimed?
    !claimed?
  end

  def status
    return :deleted if deleted_at.present?
    return :inbound_claimed if claimed?
    return :inbound_unclaimed if inbound?
    return :outbound
  end

  def dollar_amount_as_number
    inbound ? dollar_amount : -dollar_amount
  end

  def claimed?
    money_transfers_escrows.present?  
  end
  
  def apply_to(escrow)
    relationships.find_or_create_by escrow_id: escrow.id
  end
end
