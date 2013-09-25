# This migration comes from spree (originally 20130923225549)
class CreateSpreeStockpiles < ActiveRecord::Migration
  def change
    create_table :spree_stockpiles do |t|
      t.integer :material_id
      t.integer :address_id
      t.integer :pounds_on_hand
      t.decimal :cost_usd_per_pound, :precision => 10, :scale => 5
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
