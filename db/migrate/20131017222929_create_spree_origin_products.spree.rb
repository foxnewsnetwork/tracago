# This migration comes from spree (originally 20131010021308)
class CreateSpreeOriginProducts < ActiveRecord::Migration
  def change
    create_table :spree_origin_products do |t|
      t.string :permalink, null: false
      t.string :presentation, null: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :spree_origin_products, [:permalink], unique: true
  end
end
