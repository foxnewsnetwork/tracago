class Itps::Escrows::EscrowEmailHelper
    
  def initialize(escrow)
    @escrow = escrow
  end

  def dispatch!
    Itps::EscrowMailer.ready_email(@escrow)
  end  
end