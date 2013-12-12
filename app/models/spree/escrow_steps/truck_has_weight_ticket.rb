class Spree::EscrowSteps::TruckHasWeightTicket < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    5
  end
end