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
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'
  has_many :payment_escrows,
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  has_many :active_service_escrows,
    -> { active },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'

  has_many :active_payment_escrows,
    -> { active },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  has_many :archived_service_escrows,
    -> { completed },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'

  has_many :archived_payment_escrows,
    -> { completed },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  has_many :in_progress_service_escrows,
    -> { inactive },
    foreign_key: 'service_party_id',
    class_name: 'Itps::Escrow'

  has_many :in_progress_payment_escrows,
    -> { inactive },
    foreign_key: 'payment_party_id',
    class_name: 'Itps::Escrow'

  def permalink
    email.to_url
  end

  def active_escrows
    active_service_escrows + active_payment_escrows
  end

  def in_progress_escrows
    in_progress_service_escrows + in_progress_payment_escrows
  end

  def archived_escrows
    archived_service_escrows + archived_payment_escrows
  end

end
