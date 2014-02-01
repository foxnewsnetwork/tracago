class DropItpsDocTags < ActiveRecord::Migration
  def up
    drop_table :itps_doc_tags
  end

  def down
    create_table :itps_doc_tags do |t|
      t.string :permalink, null: false
      t.string :title, null: false
      t.integer :parent_id
      t.integer :documentation_id
      t.integer :level, null: false, default: 0
    end
    add_index :itps_doc_tags, [:permalink]
    add_index :itps_doc_tags, [:parent_id]
  end
end
