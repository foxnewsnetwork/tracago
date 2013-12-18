class CreateItpsEscrowsSteps < ActiveRecord::Migration
  def change
    create_table :itps_escrows_steps do |t|
      t.references :escrow, null: false, index: true
      t.string :title, null: false
      t.string :permalink, null: false
      t.text :instructions, null: false
      t.datetime :completed_at
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :itps_escrows_steps, [:permalink], unique: true
  end
end
