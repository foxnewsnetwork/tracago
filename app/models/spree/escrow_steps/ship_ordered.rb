class Spree::EscrowSteps::ShipOrdered < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    1
  end
end