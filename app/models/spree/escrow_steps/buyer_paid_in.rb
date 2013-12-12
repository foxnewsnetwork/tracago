class Spree::EscrowSteps::BuyerPaidIn < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    0
  end
end