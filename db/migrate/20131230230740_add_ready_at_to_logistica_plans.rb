class AddReadyAtToLogisticaPlans < ActiveRecord::Migration
  def change
    add_column :logistica_plans, :ready_at, :datetime
  end
end
