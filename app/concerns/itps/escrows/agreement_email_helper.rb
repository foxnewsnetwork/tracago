class Itps::Escrows::EscrowEmailHelper
  
  def initialize(escrow)
    @escrow = escrow
  end

  def dispatch!
    Itps::Escrows::AgreementMailer.create_email(@escrow)
  end  
end