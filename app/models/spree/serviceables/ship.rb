# == Schema Information
#
# Table name: spree_serviceables_ships
#
#  id                   :integer          not null, primary key
#  start_port_id        :integer          not null
#  start_terminal_code  :string(255)
#  finish_port_id       :integer          not null
#  finish_terminal_code :string(255)
#  carrier_name         :string(255)
#  vessel_id            :string(255)
#  depart_at            :datetime
#  arrive_at            :datetime
#  cutoff_at            :datetime
#  pull_at              :datetime
#  return_at            :datetime
#  lategate_at          :datetime
#  containers           :integer          default(1), not null
#  usd_price            :decimal(10, 2)
#  contact_name         :string(255)
#  contact_email        :string(255)
#  contact_phone        :string(255)
#  deleted_at           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

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

  def summary
    "#{origination.summary} to #{destination.summary} on #{carrier_name}"
  end
end
