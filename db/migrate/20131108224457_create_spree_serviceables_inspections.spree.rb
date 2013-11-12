# This migration comes from spree (originally 20131108181006)
class CreateSpreeServiceablesInspections < ActiveRecord::Migration
  def change
    create_table :spree_serviceables_inspections do |t|
      t.datetime :inspected_at
      t.decimal :usd_price
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
