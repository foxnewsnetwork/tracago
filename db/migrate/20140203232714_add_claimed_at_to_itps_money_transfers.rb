class AddClaimedAtToItpsMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :itps_money_transfers, :claimed_at, :datetime
  end
end
