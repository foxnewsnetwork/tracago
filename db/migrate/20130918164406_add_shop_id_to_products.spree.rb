# This migration comes from spree (originally 20130917180152)
class AddShopIdToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :shop_id, :integer
    add_index :spree_products, ['shop_id']
  end
end
