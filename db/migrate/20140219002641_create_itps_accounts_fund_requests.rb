class CreateItpsAccountsFundRequests < ActiveRecord::Migration
  def change
    create_table :itps_accounts_fund_requests do |t|
      t.references :account, index: true
      t.decimal :dollar_amount, precision: 16, scale: 2
      t.datetime :fulfilled_at
      t.timestamps
    end
  end
end
