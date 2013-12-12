class Spree::EscrowSteps::ShipDeparts < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    7
  end
end