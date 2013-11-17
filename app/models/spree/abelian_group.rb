module Spree
  class AbelianGroup < ::ActiveRecord::Base
    self.table_name = "spree_stockpiles_taxons"
    belongs_to :stockpile, class_name: 'Spree::Stockpile'
    belongs_to :taxon, class_name: 'Spree::Taxon'
  end
end