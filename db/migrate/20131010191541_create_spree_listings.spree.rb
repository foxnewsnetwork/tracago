# This migration comes from spree (originally 20130923225022)
class CreateSpreeListings < ActiveRecord::Migration
  def change
    create_table :spree_listings do |t|
      t.integer :stockpile_id, :null => false
      t.references :shop
      t.integer :days_to_refresh
      t.datetime :available_on
      t.datetime :expires_on
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :spree_listings, [:stockpile_id], :unique => true
  end
end
