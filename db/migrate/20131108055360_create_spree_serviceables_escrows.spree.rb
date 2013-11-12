# This migration comes from spree (originally 20131108005812)
class CreateSpreeServiceablesEscrows < ActiveRecord::Migration
  def change
    create_table :spree_serviceables_escrows do |t|
      t.datetime :buyer_paid_at
      t.datetime :buyer_received_at
      t.datetime :seller_shipped_at
      t.datetime :seller_paid_at
      t.string :external_id
      t.string :external_type
      t.integer :payment_amount, null: false
      t.datetime :cancelled_at
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
