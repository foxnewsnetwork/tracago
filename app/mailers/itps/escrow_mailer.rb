class Itps::EscrowMailer < Itps::BaseMailer
  def single_ready_email(escrow)
    @escrow = escrow
    mail to: @escrow.other_party.email, 
      subject: "Contract with other party requires confirmation"
  end

  def both_ready_email(escrow)
    @escrow = escrow
    mail to: @escrow.payment_party.email,
      cc: @escrow.service_party.email,
      subject: "Both parties have agreed!"
  end
end