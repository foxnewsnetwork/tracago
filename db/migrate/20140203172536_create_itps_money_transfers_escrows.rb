class CreateItpsMoneyTransfersEscrows < ActiveRecord::Migration
  def change
    create_table :itps_money_transfers_escrows do |t|
      t.references :money_transfer, index: true
      t.references :escrow, index: true
      t.string :memo
      t.timestamps
    end
  end
end
