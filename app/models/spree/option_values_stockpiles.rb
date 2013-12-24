# == Schema Information
#
# Table name: spree_option_values_stockpiles
#
#  id              :integer          not null, primary key
#  option_value_id :integer
#  stockpile_id    :integer
#

module Spree
  class OptionValuesStockpiles < ::ActiveRecord::Base
    belongs_to :option_values
    belongs_to :stockpiles
  end
end
