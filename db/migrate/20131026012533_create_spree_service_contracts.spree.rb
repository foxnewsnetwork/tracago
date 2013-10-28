# This migration comes from spree (originally 20131026012148)
class CreateSpreeServiceContracts < ActiveRecord::Migration
  def change
    create_table :spree_service_contracts do |t|
      t.references :finalization, index: true
      t.references :shop, index: true
      t.references :serviceable, index: false, polymorphic: true
    end
    add_index :spree_service_contracts, [:serviceable_id, :serviceable_type], name: 'idx_contracts_sid_stype'
  end
end
