class CreateItpsDrafts < ActiveRecord::Migration
  def change
    create_table :itps_drafts do |t|
      t.references :account, index: true
      t.string :permalink, null: false
      t.text :content
      t.timestamps
    end
    add_index :itps_drafts, [:permalink], unique: true
  end
end
