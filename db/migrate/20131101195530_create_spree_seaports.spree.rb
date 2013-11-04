# This migration comes from spree (originally 20131101184510)
class CreateSpreeSeaports < ActiveRecord::Migration
  def change
    create_table :spree_seaports do |t|
      t.string :port_code, null: false
      t.string :port_name
      t.references :address, index: true
    end
    add_index :spree_seaports, :port_code, unique: true
  end
end
