# This migration comes from spree (originally 20131108053359)
class CreateSpreeDisputeNegotiations < ActiveRecord::Migration
  def change
    create_table :spree_dispute_negotiations do |t|
      t.references :shop, index: true
      t.references :post_transaction, index: true
      t.integer :amount
      t.text :comment
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
