# == Schema Information
#
# Table name: itps_accounts_roles
#
#  id         :integer          not null, primary key
#  role_name  :string(255)      not null
#  account_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Itps::Accounts::Role < ActiveRecord::Base
  AccessLevels = {
    admin: 8,
    slave: 4,
    user: 2,
    scumbag: 1
  }
  belongs_to :account,
    class_name: 'Itps::Account',
    touch: true

  def access_level
    AccessLevels[role_name].to_i
  end
end
