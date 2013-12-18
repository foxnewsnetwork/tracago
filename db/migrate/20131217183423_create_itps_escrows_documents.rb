class CreateItpsEscrowsDocuments < ActiveRecord::Migration
  def change
    create_table :itps_escrows_documents do |t|
      t.string :title
      t.text :description
      t.string :permalink, null: false
      t.datetime :approved_at
      t.datetime :rejected_at
      t.references :step, null: false, index: true
      t.timestamps
    end
    add_index :itps_escrows_documents, [:permalink], unique: true
  end
end
