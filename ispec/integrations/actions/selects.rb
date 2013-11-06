class ChineseIntegration::Actions::Selects < ChineseIntegration::Action
  attr_accessor :option

  def call(option)
    tap do |c|
      c.option = option
    end
  end

  def in(xpath)
    state.find_and_select xpath, option
  end
end