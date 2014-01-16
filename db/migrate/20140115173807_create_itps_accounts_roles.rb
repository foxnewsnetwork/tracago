class CreateItpsAccountsRoles < ActiveRecord::Migration
  def change
    create_table :itps_accounts_roles do |t|
      t.string :role_name, null: false
      t.references :account, null: false
      t.timestamps
    end
  end
end
