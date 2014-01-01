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

