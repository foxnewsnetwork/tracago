class Itps::DocumentMailer < Itps::BaseMailer
  
  def approve_success_email(document)
    @document = document
    @step = @document.step
    @escrow = @step.escrow
    m = mail to: @escrow.payment_party.email,
      cc: @escrow.service_party.email,
      subject: "#{@document.full_presentation} has been approved." 
    m.deliver!
  end

  def reject_success_email(document)
    @document = document
    @step = @document.step
    @escrow = @step.escrow
    m = mail to: @escrow.payment_party.email,
      cc: @escrow.service_party.email,
      subject: "#{@document.full_presentation} has been rejected."
    m.deliver!
  end
end

