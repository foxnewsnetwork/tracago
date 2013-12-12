class Spree::EscrowSteps::TruckOrdered < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    2
  end
end