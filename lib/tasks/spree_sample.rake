namespace :spree_sample do

  desc "Unseeds the stuff loaded into the database with rake spree_sample:load"
  task :unload => :environment do
    tables = [
      "payment_methods", 
      "shipping_categories", 
      "shipping_methods", 
      "tax_categories",
      "tax_rates",
      "users",
      "shops",
      "products",
      "taxonomies",
      "taxons",
      "option_values",
      "option_types",
      "addresses",
      "variants",
      "stock_quantities"
    ].map { |name| "spree_#{name}" }

    tables.each do |table|
      ActiveRecord::Base.connection.execute "delete from #{table}"
    end
  end

  desc "Unloads and loads the seeds"
  task :reload => :environment do
    Rake::Task['spree_sample:unload'].invoke
    Rake::Task['spree_sample:load'].invoke
  end
end