class Spree::EscrowSteps::BuyerReceivesGoods < Spree::EscrowStep
  self.table_name = 'spree_escrow_steps'

  def position
    9
  end
end