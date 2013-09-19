# This migration comes from spree (originally 20130918001157)
class CreateSpreeStockQuantities < ActiveRecord::Migration
  def change
    create_table :spree_stock_quantities do |t|
      t.integer :pounds_on_hand
      t.integer :variant_id
      t.datetime :availability_start
      t.datetime :availability_end

      t.timestamps
    end
    add_index :spree_stock_quantities, [:variant_id]
  end
end
