# This migration comes from spree (originally 20131026012308)
class CreateSpreeServiceablesShips < ActiveRecord::Migration
  def change
    create_table :spree_serviceables_ships do |t|
      t.references :start_port, null: false, index: true
      t.string :start_terminal_code
      t.references :finish_port, null: false, index: true
      t.string :finish_terminal_code
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
  end
end
