# == Schema Information
#
# Table name: logistica_steps
#
#  id           :integer          not null, primary key
#  plan_id      :integer
#  presentation :string(255)
#  permalink    :string(255)
#  step_type    :string(255)      not null
#  position     :integer          default(0), not null
#  notes        :text
#  expires_at   :datetime
#  rejected_at  :datetime
#  approved_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Logistica::Steps::LoadupContainers < Logistica::Step
  self.table_name = 'logistica_steps'
end
