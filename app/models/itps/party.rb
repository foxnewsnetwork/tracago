# == Schema Information
#
# Table name: itps_parties
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  email        :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Itps::Party < ActiveRecord::Base
  self.table_name = 'itps_parties'
  belongs_to :account,
    foreign_key: "email",
    primary_key: "email",
    class_name: 'Itps::Account'
  has_many :service_escrows,
    foreign_key: 'service_escrow_id',
    class_name: 'Itps::Escrow'
  has_many :payment_escrows,
    foreign_key: 'payment_escrow_id',
    class_name: 'Itps::Escrow'

  def permalink
    email.to_url
  end
end
