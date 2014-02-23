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
#  memo          :string(255)
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

  scope :unfulfilled,
    -> { where "#{self.table_name}.fulfilled_at is null" }
  scope :fulfilled,
    -> { where "#{self.table_name}.fulfilled_at >= ?", 100.years.ago }

  def status
    return :fulfilled if fulfilled_at.present?
    return :pending
  end

  def fulfill!(*images)
    _update_fulfill_at && _update_images(images)
  end
  private
  def _update_fulfill_at
    update fulfilled_at: DateTime.now
  end
  def _update_images(images)
    images.map { |image| files.create image: image }
  end
  def _cannot_exceed_credits
    errors.add :funds, 'cannot exceed available credit' if account.credit <= dollar_amount.to_i
  end
end
