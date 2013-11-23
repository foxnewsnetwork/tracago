# This migration comes from spree (originally 20130923230916)
class CreateSpreeShops < ActiveRecord::Migration
  def change
    create_table :spree_shops do |t|
      t.integer :user_id
      t.datetime :deleted_at
      t.string :email
      t.integer :address_id
      t.string :name, null: false
      t.string :permalink, null: false
      t.timestamps
    end
    add_index :spree_shops, [:permalink], :unique => true
  end
end
