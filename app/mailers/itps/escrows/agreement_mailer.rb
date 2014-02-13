class Itps::Escrows::AgreementMailer < Itps::BaseMailer
  attr_hash_accessor :escrow
  def create_email(escrow, to=nil)
    self.mailer_method = 'create_email'
    self.escrow = escrow
    self.to = to || @escrow.draft_party.email
    self.subject = '#{escrow.full_presentation} accepted by other party'
    mail _mail_params
  end
end