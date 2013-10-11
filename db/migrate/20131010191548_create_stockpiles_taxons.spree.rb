# This migration comes from spree (originally 20130925011240)
class CreateStockpilesTaxons < ActiveRecord::Migration
  def change
    create_table :spree_stockpiles_taxons do |t|
      t.integer :stockpile_id
      t.integer :taxon_id
    end
    add_index :spree_stockpiles_taxons, [:stockpile_id]
    add_index :spree_stockpiles_taxons, [:taxon_id]
  end
end
