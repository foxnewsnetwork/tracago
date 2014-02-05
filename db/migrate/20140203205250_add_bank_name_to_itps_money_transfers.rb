class AddBankNameToItpsMoneyTransfers < ActiveRecord::Migration
  def change
    add_column :itps_money_transfers, :bank_name, :string
  end
end
