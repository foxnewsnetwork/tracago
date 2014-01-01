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