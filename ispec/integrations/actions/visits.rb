class ChineseIntegration::Actions::Visits < ChineseIntegration::Action
  def call(url)
    state.visit url
  end
end