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

class Logistica::Plans::LocalPlan < Logistica::Plan
  self.table_name = 'logistica_plans'
  class << self
    def steps_permalink
      [
        :acquire_appointment,
        :goto_load_site,
        :loadup_truck,
        :goods_received    
      ]
    end
  end
end
