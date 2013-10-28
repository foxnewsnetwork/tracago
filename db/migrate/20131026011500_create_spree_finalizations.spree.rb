# This migration comes from spree (originally 20131024190215)
class CreateSpreeFinalizations < ActiveRecord::Migration
  def change
    create_table :spree_finalizations do |t|
      t.references :offer, index: true
      t.datetime :expires_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
