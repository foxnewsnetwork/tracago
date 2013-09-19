# This migration comes from spree (originally 20130917014256)
class CreateSpreeShops < ActiveRecord::Migration
  def change
    create_table :spree_shops do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end
  end
end
