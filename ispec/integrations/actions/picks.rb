class ChineseIntegration::Actions::Picks < ChineseIntegration::Action
  attr_accessor :date

  def call(date)
    tap do |c|
      c.date = date
    end
  end

  def in(xpath)
    state.find_and_pick xpath, date
  end
end