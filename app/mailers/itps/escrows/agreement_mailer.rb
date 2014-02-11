class Itps::Escrows::AgreementMailer < Itps::BaseMailer
  def create_email(escrow, to=nil)
    @escrow = escrow
    m = mail to: (to || @escrow.draft_party.email),
      subject: 'Contract accepted by other party'
    m.deliver!
  end
end