class Itps::Escrows::AgreementMailer < ActionMailer::Base
  default from: 'mail.clerk@someemailaccount.com'
  def create_email(escrow)
    @escrow = escrow
    mail_to to: @escrow.draft_party.email,
      subject: 'Contract accepted by other party'
  end
end