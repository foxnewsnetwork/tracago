class Itps::Admins::MoneyTransfers::PutsFormHelper < Spree::FormHelperBase
  Fields = [
    :routing_number,
    :account_number,
    :bank_name,
    :name_on_account,
    :dollar_amount,
    :memo
  ].freeze
  attr_hash_accessor *Fields
  attr_accessor :attributes, :money_transfer

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

  def initialize(money_transfer)
    super
    self.attributes = money_transfer.attributes.symbolize_keys.permit(*Fields)
    self.routing_number = money_transfer.routing_number
    self.account_number = money_transfer.account_number
    self.money_transfer = money_transfer
  end

  def update_transfer!
    self.money_transfer.update _money_params if valid?
  end

  private
  def _money_params
    return _raw_params.merge _bank_params if _bank_changed?
    _raw_params
  end

  def _raw_params
    attributes.permit(:bank_name, :name_on_account, :dollar_amount, :memo)
  end

  def _bank_params
    { bank_account: _bank_account }
  end

  def _bank_account
    @bank_account ||= Itps::Parties::BankAccount.find_or_create_by routing_number: routing_number, 
      account_number: account_number
  end

  def _bank_changed?
    routing_number != money_transfer.routing_number || account_number != money_transfer.account_number
  end
end