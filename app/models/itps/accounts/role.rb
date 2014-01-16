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