class CreateItpsDraftsItems < ActiveRecord::Migration
  def change
    create_table :itps_drafts_items do |t|
      t.references :draft, index: true
      t.string :name
      t.string :unit
      t.decimal :price, scale: 8, precision: 16
      t.decimal :quantity, scale: 8, precision: 16
      t.timestamps
    end
  end
end
