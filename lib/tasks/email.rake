namespace :emails do
  desc 'Batch tests all the emails to me'
  task batch_test: :environment do
    require Rails.root.join "spec", "factories", "base_factory"
    Dir[Rails.root.join("spec/factories/*/*.rb")].each { |f| require f }
    mails = []
    escrow = JewFactory::Escrow.mock
    mails.push Itps::Escrows::AgreementMailer.create_email escrow
    escrow.payment_party_agree!
    mails.push Itps::EscrowMailer.single_ready_email Itps::Escrow.last
    escrow.service_party_agree!
    mails.push Itps::EscrowMailer.both_ready_email Itps::Escrow.last
    mails.each do |mail|
      mail.to = 'doitfaggot@mailinator.com'
      puts mail.deliver!
    end
  end

  desc "Sends out a test email to me"
  task test: :environment do
    male = Itps::TestMailer.test_email 'hell@mailinator.com'
    puts male.perform_deliveries
  end

  desc "Tests the mail gem"
  task test_mail: :environment do
    require 'mail'
    Mail.defaults do
      delivery_method :smtp, address: 'localhost', 
        domain: 'globaltradepayment.co',
        port: 25,
        tls: false,
        ssl: false,
        enable_starttls_auto: false,
        authentication: 'plain'
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