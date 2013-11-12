# This migration comes from spree (originally 20131107204250)
class CreateSpreeRatings < ActiveRecord::Migration
  def change
    create_table :spree_ratings do |t|
      t.integer :trustworthiness, null: false
      t.integer :simplicity, null: false
      t.integer :agreeability, null: false
      t.text :notes
      t.references :shop, index: true
      t.references :reviewer, index: true
      t.references :reviewable, index: true, polymorphic: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
