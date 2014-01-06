class Itps::Escrows::EscrowEmailHelper
    
  def initialize(escrow)
    @escrow = escrow
  end

  def inform_remaining_party_contract_is_ready!
    Itps::EscrowMailer.single_ready_email(@escrow)
  end

  def inform_both_parties_of_mutual_agreement!
    Itps::EscrowMailer.both_ready_email(@escrow)
  end

end