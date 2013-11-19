class Spree::Serviceables::Truck < Spree::Serviceable
  self.table_name = 'spree_serviceables_trucks'

  belongs_to :origination,
    class_name: 'Spree::Address'

  belongs_to :destination,
    class_name: 'Spree::Address'

  def summary
    "#{origination.permalink_name} to #{destination.permalink_name}"
  end
end