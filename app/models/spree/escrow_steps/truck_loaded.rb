class Spree::EscrowSteps::TruckLoaded < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    4
  end
end