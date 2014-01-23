namespace :emails do
  desc "Sends out a test email to me"
  task test: :environment do
    puts Itps::TestMailer.test_email 'foxnewsnetwork@gmail.com', 'black_dogs_everywhere@mailinator.com'
  end
end