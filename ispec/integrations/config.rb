class ChineseIntegration::Config
  include Singleton
  attr_accessor :driver, :host_url, :session_class

  def initialize
    @driver = :selenium
    @host_url = "http://localhost:3000"
    @session_class = Capybara::Session
  end

end