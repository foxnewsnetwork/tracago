class Itps::EscrowMailer < Itps::BaseMailer
  attr_hash_accessor :escrow
  def single_ready_email(escrow, to=nil)
    self.mailer_method = 'single_ready_email'
    self.escrow = escrow
    self.to = to || escrow.other_party.email
    self.subject = "#{escrow.full_presentation} with other party requires confirmation"
    mail _mail_params
  end

  def both_ready_email(escrow, to=nil)
    self.mailer_method = 'both_ready_email'
    self.escrow = escrow
    self.to = to || escrow.payment_party.email
    self.subject = "#{escrow.full_presentation}: Both parties have agreed!"
    mail _mail_params
  end
end