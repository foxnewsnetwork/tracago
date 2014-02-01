class CreateItpsTagsTags < ActiveRecord::Migration
  def change
    create_table :itps_tags_tags do |t|
      t.references :parent, null: false, index: false
      t.references :child, null: false, index: true
      t.integer :count, null: false, default: 0
      t.timestamps
    end
    add_index :itps_tags_tags, [:parent_id, :child_id], unique: true
  end
end
