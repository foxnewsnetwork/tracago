class Spree::Serviceable < ActiveRecord::Base
  has_one :service_contract, as: :serviceable
  self.abstract_class = true

end