class Itps::DocumentMailer < ActionMailer::Base
  default from: 'no-reply@thiswebsite.com'
  def approve_success_email(document)
    @document = document
    @step = @document.step
    @escrow = @step.escrow
    mail to: @escrow.payment_party.email,
      cc: @escrow.service_party.email,
      subject: "#{@document.full_presentation} has been approved." 
  end

  def reject_success_email(document)
    @document = document
    @step = @document.step
    @escrow = @step.escrow
    mail to: @escrow.payment_party.email,
      cc: @escrow.service_party.email,
      subject: "#{@document.full_presentation} has been rejected."
  end
end

