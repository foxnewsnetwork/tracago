# == Schema Information
#
# Table name: spree_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)
#  password_salt          :string(255)
#  login                  :string(255)
#  ship_address_id        :integer
#  bill_address_id        :integer
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  remember_token         :string(255)
#  persistence_token      :string(255)
#  single_access_token    :string(255)
#  perishable_token       :string(255)
#  sign_in_count          :integer          default(0), not null
#  failed_attempts        :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  last_request_at        :datetime
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  openid_identifier      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  shop_id                :integer
#

require 'spec_helper'

describe Itps::Account do
  describe '::id_to_permalink' do
    it 'should commute back and forth with perma_link to id' do
      100.times do
        num = rand(9999999)
        num.should eq Itps::Account.permalink_to_id Itps::Account.id_to_permalink num
      end
    end
  end
end