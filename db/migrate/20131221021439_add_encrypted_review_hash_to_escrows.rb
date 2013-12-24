class AddEncryptedReviewHashToEscrows < ActiveRecord::Migration
  def change
    add_column :itps_escrows, :payment_party_agree_key, :string
    add_column :itps_escrows, :service_party_agree_key, :string
    add_index :itps_escrows, :payment_party_agree_key, unique: true
    add_index :itps_escrows, :service_party_agree_key, unique: true
  end
end
