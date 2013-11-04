class ChineseFactory::Locatables
  Dir[File.expand_path("../locatables/*", __FILE__)].each { |f| require f }
  def self.mock
    new.mock
  end

  def initialize
    @seed = rand 100
  end

  def mock
    case @seed
    when 0..32
      ChineseFactory::Locatables::PersonalAddress.mock
    when 33..66
      ChineseFactory::Locatables::PortAddress.mock
    when 67..100
      ChineseFactory::Locatables::CompanyAddress.mock
    else
      raise fjaskldf, rj22
    end
  end
end