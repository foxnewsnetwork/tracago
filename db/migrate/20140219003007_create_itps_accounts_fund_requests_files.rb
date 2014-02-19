class CreateItpsAccountsFundRequestsFiles < ActiveRecord::Migration
  def change
    create_table :itps_accounts_fund_requests_files do |t|
      t.references :fund_request, index: true
      t.references :file, index: true
    end
  end
end
