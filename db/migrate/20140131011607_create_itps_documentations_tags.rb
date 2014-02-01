class CreateItpsDocumentationsTags < ActiveRecord::Migration
  def change
    create_table :itps_documentations_tags do |t|
      t.references :documentation, index: true, null: false
      t.references :tag, index: true, null: false
      t.integer :count, null: false, default: 0
      t.timestamps
    end
  end
end
