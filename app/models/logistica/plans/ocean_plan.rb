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

class Logistica::Plans::OceanPlan < Logistica::Plan
  self.table_name = 'logistica_plans'
  class << self
    def steps_permalink
      [
        :acquire_booking,
        :pull_containers,
        :acquire_appointment,
        :goto_load_site,
        :loadup_containers,
        :return_containers,
        :goods_received
      ]
    end
  end
  
end

