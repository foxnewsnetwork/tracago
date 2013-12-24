class ChineseFactory::OriginProduct
  class << self
    def mock
      new.create
    end
  end
  def create
    Spree::OriginProduct.create! attributes
  end

  def attributes
    { presentation: Faker::Name.name }
  end
end