# == Schema Information
#
# Table name: itps_drafts_punishments
#
#  id               :integer          not null, primary key
#  draft_id         :integer
#  minimum_quantity :decimal(16, 6)
#  maximum_quantity :decimal(16, 6)
#  comparison_type  :string(255)
#  quantity_unit    :string(255)
#  price_deduction  :decimal(16, 8)
#  price_unit       :string(255)
#  memo             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Itps::Drafts::Punishment < ActiveRecord::Base
  class ComparisonTypeValidator < ::ActiveModel::Validator
    def validate(model)
      _validate_packing_model model if _packing_weight_type? model
      _validate_shipment_model model if _shipment_load_type? model
    end

    private
    def _validate_packing_model(model)
      return if 'lbs' == model.quantity_unit
      model.errors.add :quantity_unit, 'should be in unit of weight'
    end
    def _validate_shipment_model(model)
      return if 'containers' == model.quantity_unit
      model.errors.add :quantity_unit, 'should be in unit of containers'
    end
    def _packing_weight_type?(model)
      'packing weight' == model.comparison_type
    end
    def _shipment_load_type?(model)
      'shipment loads' == model.comparison_type
    end

  end
  self.table_name = 'itps_drafts_punishments'
  ComparisonTypes = ['packing weight', 'shipment loads'].freeze
  belongs_to :draft,
    class_name: 'Itps::Draft'

  validates :minimum_quantity,
    :maximum_quantity,
    :price_deduction,
    :price_unit,
    :quantity_unit,
    :comparison_type,
    presence: true

  validates :comparison_type,
    inclusion: { in: ComparisonTypes }

  validates :minimum_quantity,
    :maximum_quantity,
    :price_deduction,
    numericality: { greater_than_or_equal_to: 0 }

  validates_with ComparisonTypeValidator

  before_create :_maintain_min_max_order

  scope :packing_weights,
    -> { where "#{self.table_name}.comparison_type = ?", 'packing weight' }

  scope :containers,
    -> { where "#{self.table_name}.comparison_type = ?", 'shipment loads' }

  private
  def _maintain_min_max_order
    if minimum_quantity > maximum_quantity
      temp_var = minimum_quantity
      self.minimum_quantity = maximum_quantity
      self.maximum_quantity = temp_var
    end
  end
end
