module Spree
  class OriginProductsStockpiles < ActiveRecord::Base
    belongs_to :origin_product, class_name: 'Spree::OriginProduct'
    belongs_to :stockpile, class_name: 'Spree::Stockpile'
  end
end
