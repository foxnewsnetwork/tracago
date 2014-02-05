class CreateItpsMoneyTransfers < ActiveRecord::Migration
  def change
    create_table :itps_money_transfers do |t|
      t.references :bank_account, index: true
      t.decimal :dollar_amount, precision: 16, scale: 2
      t.boolean :inbound, null: false, default: true
      t.string :memo
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
