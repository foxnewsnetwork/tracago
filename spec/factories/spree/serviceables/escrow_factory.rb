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

class ChineseFactory::Serviceables::Escrow < ChineseFactory::Base

  def attributes
    {
      payment_amount: rand(230842)
    }
  end
end
