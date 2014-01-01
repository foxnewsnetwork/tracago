class CreateLogisticaProofs < ActiveRecord::Migration
  def change
    create_table :logistica_proofs do |t|
      t.references :step, index: true
      t.references :provable, polymorphic: true
      t.string :title
      t.string :permalink
      t.datetime :expires_at
      t.datetime :rejected_at
      t.datetime :approved_at
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
