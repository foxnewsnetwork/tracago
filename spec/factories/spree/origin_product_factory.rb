# == Schema Information
#
# Table name: spree_origin_products
#
#  id           :integer          not null, primary key
#  permalink    :string(255)      not null
#  presentation :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

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
