# == Schema Information
#
# Table name: itps_parties_bank_accounts
#
#  id             :integer          not null, primary key
#  account_number :string(255)      not null
#  routing_number :string(255)      not null
#  party_id       :integer
#  deleted_at     :datetime
#  expires_at     :datetime
#  defaulted_at   :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class Itps::Parties::BankAccount < ActiveRecord::Base
  BankName = 'Bank of America'.freeze
  RoutingNumber = '121000358'.freeze
  AccountNumber = '325020894955'.freeze
  CorporateAddress = '1810 Pippin LN, San Luis Obispo, CA 93405-8043'
  belongs_to :party,
    class_name: 'Itps::Party'

  has_many :money_transfers,
    class_name: 'Itps::MoneyTransfer'
    
  scope :ordered_by_defaulted_at,
    -> { order("#{self.table_name}.defaulted_at desc") }
  before_create :_set_defaulted_at

  validates :account_number, 
    :routing_number,
    presence: true,
    format: { with: /\d{4,10}/ },
    length: { minimum: 4, maximum: 10 }
  
  class << self
    def itps_routing_number
      RoutingNumber
    end

    def itps_account_number
      AccountNumber
    end

    def find_by_bullshit_id!(number)
      find _unbullshitify number
    end

    def bank_hash
      @bank_hash ||= YAML.load File.read Rails.root.join "config", "banks.yml"
    end

    private
    def _bullshitify(number)
      (number.to_i + 13733) * 28 - 13
    end
    
    def _unbullshitify(number)
      (number.to_i + 13) / 28 - 13733
    end
  end
  def bank_name
    self.class.bank_hash["banks"][routing_number.to_i] || I18n.t(:unknown_bank)
  end

  def bullshit_id
    self.class.send :_bullshitify, id
  end

  private

  def _set_defaulted_at
    self.defaulted_at = DateTime.now
  end
end
