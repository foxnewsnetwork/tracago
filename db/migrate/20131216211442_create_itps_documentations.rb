class CreateItpsDocumentations < ActiveRecord::Migration
  def change
    create_table :itps_documentations do |t|
      t.string :permalink, null: false
      t.string :title, null: false
      t.text :body
      t.timestamps
    end
    add_index :itps_documentations, [:permalink]
  end
end
