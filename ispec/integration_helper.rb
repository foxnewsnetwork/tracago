require 'capybara'
require 'ffaker'

Capybara.default_driver = :selenium
require Rails.root.join "spec", "integrations", "action"
Dir[Rails.root.join("spec", "integrations", "*.rb")].each { |f| require f }