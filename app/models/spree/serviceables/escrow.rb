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