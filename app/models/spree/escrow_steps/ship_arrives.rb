class Spree::EscrowSteps::ShipArrives < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    8
  end
end