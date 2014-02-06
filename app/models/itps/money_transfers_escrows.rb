# == Schema Information
#
# Table name: itps_money_transfers_escrows
#
#  id                :integer          not null, primary key
#  money_transfer_id :integer
#  escrow_id         :integer
#  memo              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Itps::MoneyTransfersEscrows < ActiveRecord::Base
  self.table_name = 'itps_money_transfers_escrows'
  belongs_to :money_transfer,
    class_name: 'Itps::MoneyTransfer'

  belongs_to :escrow,
    class_name: 'Itps::Escrow'

  # Obviously not thread-safe, luckily this isn't a big deal
  # since the use case is admin-only
  after_create :_claim_money_transfer, :_claim_escrow
  after_destroy :_unclaim_money_transfer, :_unclaim_escrow

  
  private
  def _claim_escrow
    escrow.update claimed_at: DateTime.now
  end

  def _unclaim_escrow
    escrow.update claimed_at: nil
  end

  def _claim_money_transfer
    money_transfer.update claimed_at: DateTime.now
  end

  def _unclaim_money_transfer
    money_transfer.update claimed_at: nil
  end

end
