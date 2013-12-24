# == Schema Information
#
# Table name: spree_seaports
#
#  id         :integer          not null, primary key
#  port_code  :string(255)      not null
#  port_name  :string(255)
#  address_id :integer
#

class Spree::Seaport < ActiveRecord::Base
  belongs_to :address,
    class_name: 'Spree::Address'
  has_many :arrivals,
    class_name: 'Spree::Serviceables::Ship',
    foreign_key: :finish_port_id
  has_many :departures,
    class_name: 'Spree::Serviceables::Ship',
    foreign_key: :start_port_id

  def summary
    "#{port_name} #{address.try :permalink_name}"
  end
end
