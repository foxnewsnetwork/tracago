class CreateLogisticaStepsOverseers < ActiveRecord::Migration
  def change
    create_table :logistica_steps_overseers do |t|
      t.references :step, index: true
      t.references :overseer, polymorphic: true, index: true
      t.string :role
    end
  end
end
