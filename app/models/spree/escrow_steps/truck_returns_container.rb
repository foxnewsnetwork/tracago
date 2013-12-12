class Spree::EscrowSteps::TruckReturnsContainer < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    6
  end
end