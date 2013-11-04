# This migration comes from spree (originally 20131028224928)
class CreateSpreeServiceDemands < ActiveRecord::Migration
  def change
    create_table :spree_service_demands do |t|
      t.references :finalization, index: true
      t.references :serviceable, index: false, polymorphic: true
    end
    add_index :spree_service_demands, 
      [:serviceable_id, :serviceable_type],
      name: 'idx_demands_sid_and_stype'
  end
end
