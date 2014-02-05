class AddNameOnAccountToItpsMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :itps_money_transfers, :name_on_account, :string
  end
end
