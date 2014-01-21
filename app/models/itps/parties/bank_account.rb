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
  belongs_to :party,
    class_name: 'Itps::Party'

  before_create :_set_defaulted_at

  validates :account_number, 
    :routing_number,
    presence: true,
    format: { with: /\d{8}/ }
  
  def bank_name
    "Implement Me You Shit"
  end

  private
  def _set_defaulted_at
    self.defaulted_at = DateTime.now
  end
end
