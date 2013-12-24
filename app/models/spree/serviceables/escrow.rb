# == Schema Information
#
# Table name: spree_serviceables_escrows
#
#  id                :integer          not null, primary key
#  buyer_paid_at     :datetime
#  buyer_received_at :datetime
#  seller_shipped_at :datetime
#  seller_paid_at    :datetime
#  external_id       :string(255)
#  external_type     :string(255)
#  payment_amount    :integer          not null
#  cancelled_at      :datetime
#  deleted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Spree::Serviceables::Escrow < Spree::Serviceable
  self.table_name = 'spree_serviceables_escrows'

  scope :buyer_paid,
    -> { where "#{self.table_name}.buyer_paid_at is not null" }

  scope :seller_shipped,
    -> { where "#{self.table_name}.seller_shipped_at is not null" }

  scope :buyer_received,
    -> { where "#{self.table_name}.buyer_received_at is not null" }

  scope :seller_paid,
    -> { where "#{self.table_name}.seller_paid_at is not null" }

  
end
