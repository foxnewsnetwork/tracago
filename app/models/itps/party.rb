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