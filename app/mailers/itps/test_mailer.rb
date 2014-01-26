class Itps::TestMailer < Itps::BaseMailer
  def test_email(*targets)
    m = mail to: targets.first,
      cc: targets.tail,
      subject: "Testing Emails"
    m.deliver!
  end
end