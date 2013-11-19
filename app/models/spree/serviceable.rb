class Spree::Serviceable < ActiveRecord::Base
  has_one :service_contract, as: :serviceable
  self.abstract_class = true

  class << self
    def all_services
      Spree::Serviceables::Ship.all + 
      Spree::Serviceables::Truck.all +
      Spree::Serviceables::Escrow.all
    end
  end

  def name
    self.class.to_s.split("::").last.underscore
  end
end