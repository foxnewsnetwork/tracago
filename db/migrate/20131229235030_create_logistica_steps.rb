class CreateLogisticaSteps < ActiveRecord::Migration
  def change
    create_table :logistica_steps do |t|
      t.references :plan, index: true
      t.string :presentation
      t.string :permalink
      t.string :step_type, null: false
      t.integer :position, null: false, default: 0
      t.text :notes
      t.datetime :expires_at
      t.datetime :rejected_at
      t.datetime :approved_at
      
      t.timestamps
    end
  end
end
