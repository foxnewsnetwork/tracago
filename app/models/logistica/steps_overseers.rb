# == Schema Information
#
# Table name: logistica_steps_overseers
#
#  id            :integer          not null, primary key
#  step_id       :integer
#  overseer_id   :integer
#  overseer_type :string(255)
#  role          :string(255)
#

class Logistica::StepsOverseers < ActiveRecord::Base
  belongs_to :step, class_name: 'Logistica::Step'
  belongs_to :overseer, polymorphic: true
end
