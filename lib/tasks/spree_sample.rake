require 'fileutils'
require 'ffaker'
require 'pathname'

namespace :spree_sample do

  desc 'Loads sample data'
  task :load => :environment do
    if ARGV.include?("db:migrate")
      puts %Q{
Please run db:migrate separately from spree_sample:load.

Running db:migrate and spree_sample:load at the same time has been known to
cause problems where columns may be not available during sample data loading.

Migrations have been run. Please run "rake spree_sample:load" by itself now.
      }
      exit(1)
    end
    require Rails.root.join "lib", "spree", "sample_engine"
    Spree::SampleEngine.load_samples
  end

  desc "Drops the database, deletes all the migrations and the schema, kills all the image assets, then reloads the migrations from spree, migrates them, seeds the database, then finishes with preparing the test database. Use this only during development."
  task :rebuild_database => :environment do
    puts "Preparing to drop the database..."
    Rake::Task['db:drop'].invoke
    puts "Success!"
    puts "Preparing to remove image assets..."
    Rake::Task['spree_sample:remove_images'].invoke
    puts "Success!"
    puts "Preparing to reinstall migrations..."
    Rake::Task['spree:reinstall:migrations'].invoke
    puts "Success!"
    puts "Preparing to recreate the database..."
    Rake::Task['db:create'].invoke
    puts 'Success!'
    puts "Preparing to migrate the database..."
    Rake::Task['db:migrate'].invoke
    puts "Success!"
    puts "Preparing to seed the database"
    Rake::Task['db:seed'].invoke
    puts "Success!"
    puts "Preparing to load the sample dataset..."
    Rake::Task['spree_sample:load'].invoke
    puts "Success!"
    puts "Preparing the test database..."
    Rake::Task['db:test:prepare'].invoke
    puts "Success!"
  end


  desc "Unseeds the stuff loaded into the database with rake spree_sample:load"
  task :unload => :environment do
    tables = ActiveRecord::Base.connection.tables.reject do |table|
      table =~ /(migrations|roles|zones)/
    end

    tables.each do |table|
      puts "Clearing out #{table}..."
      ActiveRecord::Base.connection.execute "delete from #{table}"
    end
  end

  desc "cleans out the assets loaded by the sample thing"
  task :remove_images => :environment do
    dir = Rails.root.join("public", "spree")
    if Dir.exists? dir
      FileUtils.rmdir dir 
      puts "removed #{dir}"
    else
      puts "failed to remove"
    end
  end

  desc "Unloads and loads the seeds"
  task :reload => :environment do
    Rake::Task['spree_sample:unload'].invoke
    Rake::Task['spree_sample:remove_images'].invoke
    Rake::Task['spree_sample:load'].invoke
  end
end