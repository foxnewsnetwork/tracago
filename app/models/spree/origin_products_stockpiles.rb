# == Schema Information
#
# Table name: spree_origin_products_stockpiles
#
#  id                :integer          not null, primary key
#  origin_product_id :integer          not null
#  stockpile_id      :integer          not null
#

module Spree
  class OriginProductsStockpiles < ActiveRecord::Base
    belongs_to :origin_product, class_name: 'Spree::OriginProduct'
    belongs_to :stockpile, class_name: 'Spree::Stockpile'
  end
end
