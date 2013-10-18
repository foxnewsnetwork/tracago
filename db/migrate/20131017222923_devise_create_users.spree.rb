# This migration comes from spree (originally 20130924171624)
class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:spree_users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password
      t.string :password_salt
      t.string     :login
      t.references :ship_address
      t.references :bill_address

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
      t.string   "remember_token"
      t.string   "persistence_token"
      t.string   "single_access_token"
      t.string   "perishable_token"

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.integer  :failed_attempts,                       :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.datetime   :last_request_at

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token
      t.string   "openid_identifier"

      t.timestamps
    end

    add_index :spree_users, :email,                :unique => true
    add_index :spree_users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    add_index :spree_users, :unlock_token,         :unique => true
    add_index :spree_users, :authentication_token, :unique => true
  end
end
