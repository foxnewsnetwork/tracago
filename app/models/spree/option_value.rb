# == Schema Information
#
# Table name: spree_option_values
#
#  id             :integer          not null, primary key
#  position       :integer
#  name           :string(255)
#  presentation   :string(255)
#  option_type_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

module Spree
  class OptionValue < ActiveRecord::Base
    belongs_to :option_type
    has_and_belongs_to_many :variants, 
      join_table: 'spree_option_values_variants',
      class_name: "Spree::Variant"
    has_and_belongs_to_many :stockpiles, 
      join_table: 'spree_option_values_stockpiles',
      class_name: 'Spree::Stockpile'
    validates :name, :presentation, presence: true

    class << self
      def normalize!(id_name_or_presentation)
        return id_name_or_presentation if id_name_or_presentation.is_a? self
        find_by_id(id_name_or_presentation) || 
        find_by_name(id_name_or_presentation) ||
        find_by_presentation(id_name_or_presentation) ||
        find(id_name_or_presentation)
      end
    end

    def to_options_array
      [presentation, id]
    end

  end
end
