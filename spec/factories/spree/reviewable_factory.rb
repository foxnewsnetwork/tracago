class ChineseFactory::Reviewable
  class << self
    def mock
      new.mock
    end
  end

  def mock
    ChineseFactory::Finalization.mock
  end
end