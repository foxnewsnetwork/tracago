class CreateItpsParties < ActiveRecord::Migration
  def change
    create_table :itps_parties do |t|
      t.string :company_name
      t.string :email, null: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :itps_parties, [:email], unique: true
  end
end
