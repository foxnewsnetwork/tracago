# This migration comes from spree (originally 20131017192415)
class ChangeContainersToLoadsInSpreeOffers < ActiveRecord::Migration
  def change
    rename_column :spree_offers, :containers, :loads
    add_column :spree_offers, :transport_method, :string, null: false, default: "CONTAINER"
    add_column :spree_offers, :minimum_pounds_per_load, :integer
  end
end
