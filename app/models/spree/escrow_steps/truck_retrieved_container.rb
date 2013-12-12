class Spree::EscrowSteps::TruckRetrievedContainer < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    3
  end
end