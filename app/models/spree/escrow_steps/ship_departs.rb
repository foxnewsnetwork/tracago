# == Schema Information
#
# Table name: spree_escrow_steps
#
#  id              :integer          not null, primary key
#  presentation    :string(255)
#  permalink       :string(255)      not null
#  finalization_id :integer
#  completed_at    :datetime
#  step_type       :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Spree::EscrowSteps::ShipDeparts < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    7
  end
end
