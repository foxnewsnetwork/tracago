namespace :admins do
  desc "Setups default admin accounts from the config/admins.yml file"
  task setup: :environment do
    Itps::Account.admins
  end
end