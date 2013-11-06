class ChineseIntegration::State
  attr_reader :session

  def initialize
    @session = Config.instance.session_class.new Config.instance.driver
  end

  def visit(url)
    session.visit url
    _check_for_response_codes!
    self
  end

  def find_and_write(xpath, content)
    _consider_missing_xpath_errors! xpath
    result = session.find(:xpath, xpath).set content
    errors.add :write, "#{content} in #{xpath}" if result.nil?
    self
  end

  def find_and_click(xpath)
    _consider_missing_xpath_errors! xpath
    result = session.find(:xpath, xpath).click
    errors.add :click, "#{xpath}" if result.blank?
    _check_for_response_codes!
    self
  end

  def find_and_select(xpath, option)
    _consider_missing_xpath_errors! xpath
    _try_selecting! xpath, option
    self
  end

  def find_and_pick(xpath, date)
    _consider_missing_xpath_errors! xpath
    result = session.find(:xpath, xpath).set date.to_formatted_s(:db)
    errors.add :pick, "#{date} in #{xpath}" if result.nil?
    self
  end

  def valid?
    errors.blank?
  end

  def errors
    @errors ||= ActiveModel::Errors.new self
  end

  private

  def _check_for_response_codes!
    errors.add session.title, "server dead" if _problem_loading_page?
    errors.add :code_404, session.title     if _code_404?
    errors.add :code_500, session.title     if _code_500?
  end

  def _code_500?
    session.title =~ /action.*controller.*exception/i
  end

  def _code_404?
    session.title =~ /.*page.*exist.*404.*/i
  end

  def _problem_loading_page?
    session.title =~ /problem loading page/i
  end

  def _try_selecting!(xpath, option)
    begin
      session.find(:xpath, xpath).select option
    rescue Capybara::ElementNotFound => e
      errors.add e.class.to_s, e.message
    end
  end

  def _consider_missing_xpath_errors!(xpath)
    errors.add :missing, xpath unless session.has_xpath? xpath
  end
end