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

class Itps::Account < ActiveRecord::Base
  self.table_name = 'spree_users'

  class << self
    def admins
      _admin_hashes.map do |hash|
        acc = find_by_email(hash["email"])
        acc ||= create! hash.merge(password_confirmation: hash["password"])
        acc.adminify!
        acc
      end
    end

    private
    def _admin_hashes
      YAML.load(File.read Rails.root.join('config', 'admins.yml'))["admins"]
    end
  end
  has_one :party,
    class_name: 'Itps::Party',
    foreign_key: 'email',
    primary_key: 'email'

  has_many :bank_accounts,
    class_name: 'Itps::Parties::BankAccount',
    through: :party
    
  has_many :roles,
    class_name: 'Itps::Accounts::Role'

  delegate :company_name,
    :active_escrows,
    :in_progress_escrows,
    :archived_escrows,
    to: :party

  validates :email,
    presence: true,
    format: { with: Devise.email_regexp }
    
  def party_with_defaults
    return _generate_party if party_without_defaults.blank?
    party_without_defaults
  end
  alias_method_chain :party, :defaults

  def adminify!
    roles.find_or_create_by role_name: :admin
  end

  def admin?
    roles.map(&:role_name).include? 'admin'
  end

  def enslave!
    roles.find_or_create_by role_name: :slave
  end

  def slave?
    roles.map(&:role_name).include? 'slave'
  end

  private
  def _generate_party
    @party ||= Itps::Party.create! email: email, company_name: 'Unnamed Party'
  end
end
