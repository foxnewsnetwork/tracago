namespace :emails do
  desc "Sends out a test email to me"
  task test: :environment do
    puts Itps::TestMailer.test_email 'hell@mailinator.com'
  end

  desc "Tests the mail gem"
  task test_mail: :environment do
    require 'mail'
    Mail.defaults do
      delivery_method :smtp, address: 'localhost', 
        domain: 'localhost',
        port: 25
    end
    Mail.deliver do
      from 'mailtest@globaltradepayment.co'
      to 'hell@mailinator.com'
      subject 'Testing naked mail gem'
      body 'body here'
    end
  end

  desc "Test Ruby"
  task test_ruby: :environment do
    require 'net/smtp'
    msg = 'Subject: This is a test email\n'
    Net::SMTP.new('localhost', 25).start do |mailer|
      puts mailer.sendmail(msg, 'rubytest@globaltradepayment.co', 'hell@mailinator.com')
    end
  end
end