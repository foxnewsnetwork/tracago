class AddShopIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :shop_id, :integer
    add_index :spree_users, [:shop_id]
  end
end
