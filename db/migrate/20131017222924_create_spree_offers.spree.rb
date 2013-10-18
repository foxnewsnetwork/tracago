# This migration comes from spree (originally 20130924182311)
class CreateSpreeOffers < ActiveRecord::Migration
  def change
    create_table :spree_offers do |t|
      t.integer :shop_id
      t.integer :listing_id
      t.integer :address_id
      t.decimal :usd_per_pound, :null => false, :default => 0, :precision => 10, :scale => 5
      t.integer :containers
      t.string :shipping_terms, :null => false, :default => "EXWORKS"

      t.timestamps
    end

    add_index :spree_offers, [:shop_id]
    add_index :spree_offers, [:listing_id]
  end
end
