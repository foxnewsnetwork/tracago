class Itps::TestMailer < Itps::BaseMailer
  def test_email(target)
    self.mailer_method = 'test_email'
    self.to = target
    self.subject = "Testing Emails"
    mail _mail_params
  end
end