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

class ChineseFactory::Serviceables::Ship < ChineseFactory::Base
  attr_accessor :start_port, :finish_port

  def initialize
    @start_port = ChineseFactory::Seaport.mock
    @finish_port = ChineseFactory::Seaport.mock
  end

  def attributes
    {
      start_port: start_port,
      start_terminal_code: "1",
      finish_port: finish_port,
      finish_terminal_code: "2",
      carrier_name: Faker::Company.name,
      vessel_id: Faker::Name.first_name,
      depart_at: 10.days.from_now,
      arrive_at: 40.days.from_now,
      cutoff_at: 4.days.from_now,
      containers: rand(4),
      pull_at: 1.day.from_now,
      return_at: 2.days.from_now,
      usd_price: rand(3243),
      contact_name: Faker::Name.name,
      contact_email: Faker::Internet.email,
      contact_phone: Faker::PhoneNumber.phone_number
    }
  end
end
