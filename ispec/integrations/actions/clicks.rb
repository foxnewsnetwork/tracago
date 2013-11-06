class ChineseIntegration::Actions::Clicks < ChineseIntegration::Action
  attr_accessor :link

  def call(link)
    tap do |c|
      c.link = link
    end
  end

  def in(xpath)
    state.find_and_click xpath: xpath
  end
end
