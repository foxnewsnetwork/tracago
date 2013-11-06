class ChineseIntegration::Actions::Writes < ChineseIntegration::Action
  attr_accessor :content

  def call(content)
    tap do |w|
      w.content = content
    end
  end

  def in(xpath)
    state.find_and_write xpath, content
  end
  
end