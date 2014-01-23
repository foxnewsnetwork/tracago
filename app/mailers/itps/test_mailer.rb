class Itps::TestMailer < Itps::BaseMailer
  def test_email(*targets)
    mail to: targets.first,
      cc: targets.tail,
      subject: "Testing Emails"
  end
end