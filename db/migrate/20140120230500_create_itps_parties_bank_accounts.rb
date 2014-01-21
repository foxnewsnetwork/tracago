class CreateItpsPartiesBankAccounts < ActiveRecord::Migration
  def change
    create_table :itps_parties_bank_accounts do |t|
      t.string :account_number, null: false
      t.string :routing_number, null: false
      t.references :party, index: true
      t.datetime :deleted_at
      t.datetime :expires_at
      t.datetime :defaulted_at
      t.timestamps
    end
  end
end
