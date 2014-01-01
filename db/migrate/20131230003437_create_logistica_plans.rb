class CreateLogisticaPlans < ActiveRecord::Migration
  def change
    create_table :logistica_plans do |t|
      t.string :plan_type, null: false
      t.string :external_reference_id
      t.text :notes
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
