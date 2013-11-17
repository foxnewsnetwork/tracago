class Spree::Serviceables::Ship < Spree::Serviceable
  self.table_name = 'spree_serviceables_ships'

  belongs_to :origination,
    class_name: 'Spree::Seaport',
    foreign_key: 'start_port_id'
  belongs_to :start_port,
    class_name: 'Spree::Seaport'

  belongs_to :destination,
    class_name: 'Spree::Seaport',
    foreign_key: 'finish_port_id'  
  belongs_to :finish_port,
    class_name: 'Spree::Seaport'
end