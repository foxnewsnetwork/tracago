# This migration comes from spree (originally 20131028224909)
class CreateSpreeServiceSupplies < ActiveRecord::Migration
  def change
    create_table :spree_service_supplies do |t|
      t.references :shop, index: true
      t.references :serviceable, index: false, polymorphic: true
    end
    add_index :spree_service_supplies, 
      [:serviceable_id, :serviceable_type],
      name: 'idx_supplies_sid_and_stype'
  end
end
