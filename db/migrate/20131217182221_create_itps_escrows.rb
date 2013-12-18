class CreateItpsEscrows < ActiveRecord::Migration
  def change
    create_table :itps_escrows do |t|
      t.references :service_party, null: false, index: true
      t.references :payment_party, null: false, index: true
      t.string :permalink, null: false
      t.string :status_key
      t.datetime :closed_at
      t.datetime :deleted_at
      t.datetime :opened_at
      t.timestamps
    end
    add_index :itps_escrows, [:permalink], unique: true
  end
end
