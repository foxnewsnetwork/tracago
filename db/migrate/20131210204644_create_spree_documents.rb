class CreateSpreeDocuments < ActiveRecord::Migration
  def change
    create_table :spree_documents do |t|
      t.string :presentation
      t.string :permalink, null: false
      t.references :documentable, polymorphic: true, index: true
      t.datetime :rejected_at
      t.string :comment
    end
    add_index :spree_documents, [:permalink]
  end
end
