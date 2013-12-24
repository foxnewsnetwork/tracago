class ChineseFactory::Serviceables
  class << self
    def mock
      new.create
    end
  end
  def initialize
    @seed = rand 10
  end

  def create
    case @seed
    when 0..4
      ChineseFactory::Serviceables::Ship.mock
    when 5..10
      ChineseFactory::Serviceables::Truck.mock
    else
      raise FuckError, "seed outside reasonable range"
    end
  end
  alias_method :mock, :create
end
Dir[File.expand_path("../serviceables/*", __FILE__)].each { |f| require f }