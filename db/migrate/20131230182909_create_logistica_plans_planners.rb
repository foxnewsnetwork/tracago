class CreateLogisticaPlansPlanners < ActiveRecord::Migration
  def change
    create_table :logistica_plans_planners do |t|
      t.references :plan, index: true
      t.references :planner, polymorphic: true, index: true
      t.string :role
    end
  end
end
