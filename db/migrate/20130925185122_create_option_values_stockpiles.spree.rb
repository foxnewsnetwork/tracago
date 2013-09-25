# This migration comes from spree (originally 20130925000304)
class CreateOptionValuesStockpiles < ActiveRecord::Migration
  def change
    create_table :spree_option_values_stockpiles do |t|
      t.integer :option_value_id
      t.integer :stockpile_id
    end
    add_index :spree_option_values_stockpiles, [:option_value_id]
    add_index :spree_option_values_stockpiles, [:stockpile_id]
  end
end
