# == Schema Information
#
# Table name: itps_accounts
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Itps::Account < ActiveRecord::Base
  self.table_name = 'spree_users'

  has_one :party,
    class_name: 'Itps::Party',
    foreign_key: 'email',
    primary_key: 'email'

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

  private
  def _generate_party
    @party ||= Itps::Party.create! email: email, company_name: 'Unnamed Party'
  end
end
