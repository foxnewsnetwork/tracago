# This migration comes from spree (originally 20131017214725)
class AddPackingWeightPoundsToSpreeListings < ActiveRecord::Migration
  def change
    add_column :spree_listings, :packing_weight_pounds, :integer
  end
end
