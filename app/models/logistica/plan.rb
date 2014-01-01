# == Schema Information
#
# Table name: logistica_plans
#
#  id                    :integer          not null, primary key
#  plan_type             :string(255)      not null
#  external_reference_id :string(255)
#  notes                 :text
#  deleted_at            :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  ready_at              :datetime
#

class Logistica::Plan < ActiveRecord::Base
  self.table_name = 'logistica_plans'
  has_many :steps, class_name: 'Logistica::Step'

  before_validation :_set_plan_type
  
  def steps_with_defaults
    return _populate_steps if steps_without_defaults.blank?
    return steps_without_defaults
  end
  alias_method_chain :steps, :defaults

  def downcast
    _downcast_class.find id
  end

  private
  def _downcast_class
    Logistica::Plans.const_get plan_type.to_s.camelcase
  end

  def _populate_steps
    _downcast_class.steps_permalink.map do |name|
      steps_without_defaults.find_or_create_by permalink: name
    end
  end

  def _set_plan_type
    self.plan_type ||= self.class.to_s.split("::").last.underscore
  end
end
