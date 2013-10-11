# This migration comes from spree (originally 20131010172921)
class CreateSpreeOriginProductsStockpiles < ActiveRecord::Migration
  def change
    create_table :spree_origin_products_stockpiles do |t|
      t.integer :origin_product_id, null: false
      t.integer :stockpile_id, null: false
    end
    add_index :spree_origin_products_stockpiles, [:stockpile_id]
    add_index :spree_origin_products_stockpiles, 
      [:origin_product_id, :stockpile_id], 
      unique: true,
      name: 'indx_ops_opid_sid'
  end
end
