class Itps::EscrowMailer < ActionMailer::Base
  default from: 'mail.clerk@someemailaccount.com'
  def ready_email(escrow)
    @escrow = escrow
    mail to: @escrow.other_party.email, 
      subject: "Contract with other party requires confirmation"
  end
end