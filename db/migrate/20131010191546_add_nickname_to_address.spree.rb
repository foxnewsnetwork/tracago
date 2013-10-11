# This migration comes from spree (originally 20130924201834)
class AddNicknameToAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :nickname, :string
  end
end
