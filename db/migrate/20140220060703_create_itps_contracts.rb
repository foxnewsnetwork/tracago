class CreateItpsContracts < ActiveRecord::Migration
  def change
    create_table :itps_contracts do |t|
      t.references :escrow, index: true
      t.string :permalink, null: false
      t.string :class_name
      t.string :introduction
      t.text :content_summary
      t.datetime :expires_at
      t.timestamps
    end
    add_index :itps_contracts, [:permalink], unique: true
  end
end
