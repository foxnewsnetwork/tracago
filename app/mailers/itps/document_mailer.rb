class Itps::DocumentMailer < Itps::BaseMailer
  attr_hash_accessor :document, :step, :escrow  
  def approve_success_email(doc, to=nil)
    self.mailer_method = 'approve_success_email'
    self.document = doc
    self.step = document.step
    self.escrow = step.escrow
    self.to = to || escrow.payment_party.email
    self.subject = "#{document.full_presentation} has been approved."
    mail _mail_params
  end

  def reject_success_email(doc, to=nil)
    self.mailer_method = 'reject_success_email'
    self.document = doc
    self.step = document.step
    self.escrow = step.escrow
    self.to = to || escrow.payment_party.email
    self.subject = "#{document.full_presentation} has been rejected."
    mail _mail_params
  end

end

