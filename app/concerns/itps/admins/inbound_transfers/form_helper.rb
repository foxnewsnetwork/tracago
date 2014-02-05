class Itps::Admins::InboundTransfers::FormHelper < Spree::FormHelperBase
  Fields = [
    :escrow_id_by_commas,
    :routing_number,
    :account_number,
    :bank_name,
    :name_on_account,
    :dollar_amount,
    :memo
  ].freeze
  attr_hash_accessor *Fields
  attr_accessor :attributes

  validates :routing_number,
    :account_number,
    :dollar_amount,
    presence: true
  validates :routing_number,
    :account_number,
    format: { with: /\d{4,10}/ },
    length: { minimum: 4, maximum: 10 }
  validates_numericality_of :dollar_amount, 
    greater_than_or_equal_to: 0
  validates_with Itps::Admins::InboundTransfers::EscrowsValidator

  def money_transfer
    @money_transfer ||= _create_money_transfer if valid?
  end

  def create_success?
    valid? && money_transfer.persisted?
  end

  def create_failed?
    !create_success?
  end

  # Used by the validator, which is why it's public not private
  def escrow_ids
    escrow_id_by_commas.split(",").map(&:strip).map(&:scrub)
  end
  private
  def _tie_money_transfer_to_escrow(money_transfer)
    return money_transfer if _escrows.empty?
    money_transfer.tap do |mt|
      _escrows.each { |escrow| mt.apply_to escrow }
    end
  end

  def _escrows
    @escrows ||= Itps::Escrow.where id: escrow_ids
  end


  def _create_money_transfer
    _bank_acount.money_transfers.create! dollar_amount: dollar_amount,
      memo: memo
  end

  def _bank_acount
    _search_for_bank_account || _create_bank_account
  end

  def _create_bank_account
    Itps::Parties::BankAccount.create! _bank_params
  end

  def _search_for_bank_account
    Itps::Parties::BankAccount.where(_bank_params).first
  end

  def _bank_params
    { routing_number: routing_number, account_number: account_number }
  end
end