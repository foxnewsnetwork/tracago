# == Schema Information
#
# Table name: spree_option_types
#
#  id           :integer          not null, primary key
#  name         :string(100)
#  presentation :string(100)
#  position     :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

module Spree
  class OptionType < ActiveRecord::Base
    has_many :option_values, -> { order(:position) }, dependent: :destroy
    has_many :product_option_types, dependent: :destroy
    has_and_belongs_to_many :prototypes, join_table: 'spree_option_types_prototypes'

    validates :name, :presentation, presence: true
    default_scope -> { order("#{self.table_name}.position") }

    accepts_nested_attributes_for :option_values, reject_if: lambda { |ov| ov[:name].blank? || ov[:presentation].blank? }, allow_destroy: true


    class << self
      def material_origin
        @material_origin ||= find_or_create_by name: "plastics-origin-product",
          presentation: "Product Origin",
          position: 3
      end
    end
  end

end
