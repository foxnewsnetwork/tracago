# This migration comes from spree (originally 20131017001402)
class AddTimeMarkersToSpreeOffers < ActiveRecord::Migration
  def change
    add_column :spree_offers, :deleted_at, :datetime
    add_column :spree_offers, :expires_at, :datetime
  end
end
