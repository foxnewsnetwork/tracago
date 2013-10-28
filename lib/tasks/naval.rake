require 'nokogiri'
require 'open-uri'
namespace :naval do

  desc 'scrapes freightforum.com and grabs all the port codes into a csv file in your db folder'
  task build_csv: :environment do
    Tracago::PortScraper.scraps_into Rails.root.join("db", "seaports.csv")
  end
end