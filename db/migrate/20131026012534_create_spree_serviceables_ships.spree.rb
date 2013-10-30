# This migration comes from spree (originally 20131026012308)
class CreateSpreeServiceablesShips < ActiveRecord::Migration
  def change
    create_table :spree_serviceables_ships do |t|
      t.string :origination_port_code, null: false
      t.string :origination_terminal 
      t.string :destination_port_code, null: false
      t.string :destination_terminal
      t.string :carrier_name
      t.string :vessel_id
      t.datetime :depart_at
      t.datetime :arrive_at
      t.datetime :cutoff_at
      t.datetime :pull_at
      t.datetime :return_at
      t.datetime :lategate_at
      t.integer :containers, null: false, default: 1
      t.decimal :usd_price, precision: 10, scale: 2
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :spree_serviceables_ships, [:origination_port_code], name: 'ship_serve_idx_opc'
    add_index :spree_serviceables_ships, [:destination_port_code], name: 'ship_serve_idx_dpc'
  end
end
