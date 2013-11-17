module Spree
  class OptionValuesStockpiles < ::ActiveRecord::Base
    belongs_to :option_values
    belongs_to :stockpiles
  end
end