# This migration comes from spree (originally 20131026012426)
class CreateSpreeServiceablesTrucks < ActiveRecord::Migration
  def change
    create_table :spree_serviceables_trucks do |t|
      t.references :origination
      t.references :destination
      t.datetime :pickup_at
      t.datetime :arrive_at
      t.decimal :usd_price, precision: 10, scale: 2
      t.timestamps
    end
  end
end
