require 'fileutils'
namespace :spree do
  namespace :uninstall do
    desc "Cleans out the migrations folder"
    task migrations: :environment do
      dir = Rails.root.join("db", "migrate")
      FileUtils.rmdir dir if Dir.exists? dir
      FileUtils.mkdir dir unless Dir.exists? dir
    end

    desc "Kills the schema"
    task schema: :environment do
      file = Rails.root.join "db", "schema.rb"
      FileUtils.rm file if File.exists? file
    end
  end
  namespace :reinstall do
    desc "Removes all the migrations and schemas then reinstalls them from spree. Don't use in production"
    task migrations: :environment do
      Rake::Task["spree:uninstall:migrations"].invoke
      Rake::Task["spree:uninstall:schema"].invoke
      Rake::Task["spree:install:migrations"].invoke
    end
  end
end