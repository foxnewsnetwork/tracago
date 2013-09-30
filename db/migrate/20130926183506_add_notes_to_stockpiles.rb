class AddNotesToStockpiles < ActiveRecord::Migration
  def change
    add_column :spree_stockpiles, :notes, :text
  end
end
