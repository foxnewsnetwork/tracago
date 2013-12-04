class AddConfirmedAtToSpreeOffers < ActiveRecord::Migration
  def change
    add_column :spree_offers, :confirmed_at, :datetime
  end
end
