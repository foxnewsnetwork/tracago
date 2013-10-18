# This migration comes from spree (originally 20130926183506)
class AddNotesToStockpiles < ActiveRecord::Migration
  def change
    add_column :spree_stockpiles, :notes, :text
  end
end
