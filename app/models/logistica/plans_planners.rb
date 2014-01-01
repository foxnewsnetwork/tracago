# == Schema Information
#
# Table name: logistica_plans_planners
#
#  id           :integer          not null, primary key
#  plan_id      :integer
#  planner_id   :integer
#  planner_type :string(255)
#  role         :string(255)
#

class Logistica::PlansPlanners < ActiveRecord::Base
  belongs_to :plan, class_name: 'Logistica::Plan'
  belongs_to :planner, polymorphic: true
end
