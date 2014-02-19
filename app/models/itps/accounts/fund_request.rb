# == Schema Information
#
# Table name: itps_accounts_fund_requests
#
#  id            :integer          not null, primary key
#  account_id    :integer
#  dollar_amount :decimal(16, 2)
#  fulfilled_at  :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Itps::Accounts::FundRequest < ActiveRecord::Base
  self.table_name = 'itps_accounts_fund_requests'
  has_many :relationships,
    class_name: 'Itps::Accounts::FundRequestsFiles'
  has_many :files,
    through: :relationships,
    class_name: 'Itps::File'

  belongs_to :account,
    class_name: 'Itps::Account'

  validates :account,
    :dollar_amount,
    presence: true
  validates_numericality_of :dollar_amount,
    greater_than_or_equal_to: 0
  validate :_cannot_exceed_credits

  private
  def _cannot_exceed_credits
    errors.add :funds, 'cannot exceed available credit' if account.credit <= dollar_amount.to_i
  end
end
