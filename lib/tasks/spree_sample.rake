namespace :spree_sample do

  desc "Unseeds the stuff loaded into the database with rake spree_sample:load"
  task :unload => :environment do
    tables = ActiveRecord::Base.connection.tables.reject do |table|
      table =~ /(migrations|countries|roles|states|zones)/
    end

    tables.each do |table|
      puts "Clearing out #{table}..."
      ActiveRecord::Base.connection.execute "delete from #{table}"
    end
  end

  desc "Unloads and loads the seeds"
  task :reload => :environment do
    Rake::Task['spree_sample:unload'].invoke
    Rake::Task['spree_sample:load'].invoke
  end
end