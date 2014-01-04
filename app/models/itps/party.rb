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

  def active_escrows(n=3)
    active_service_escrows.limit(n) + active_payment_escrows.limit(n)
  end

  def in_progress_escrows(n=3)
    in_progress_service_escrows.limit(n) + in_progress_payment_escrows.limit(n)
  end

  def archived_escrows(n=3)
    archived_service_escrows.limit(n) + archived_payment_escrows.limit(n)
  end

  private
  def _limit_sort_merge(es, n=3)
    es.sort do |a,b|
      b.updated_at <=> a.updated_at
    end.take n
  end

end
