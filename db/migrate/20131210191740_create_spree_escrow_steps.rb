class CreateSpreeEscrowSteps < ActiveRecord::Migration
  def change
    create_table :spree_escrow_steps do |t|
      t.string :presentation
      t.string :permalink, null: false
      t.references :finalization, index: true
      t.datetime :completed_at
      t.string :step_type, null: false
      t.timestamps
    end
    add_index :spree_escrow_steps, [:permalink]
  end
end
