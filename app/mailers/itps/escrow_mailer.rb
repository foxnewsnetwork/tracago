class Itps::EscrowMailer < ActionMailer::Base

  def open_email(escrow)
    @escrow = escrow
    mail to: party.email, subject: "Contract with other party requires confirmation"
  end
end