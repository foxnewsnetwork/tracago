class AddMemoToItpsAccountsFundRequests < ActiveRecord::Migration
  def change
    add_column :itps_accounts_fund_requests, :memo, :string
  end
end
