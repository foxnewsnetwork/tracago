module Spree
  class Seaport < ActiveRecord::Base
    belongs_to :address
    has_many :arrivals,
      class_name: 'Spree::Serviceables::Ship',
      foreign_key: :finish_port_id
    has_many :departures,
      class_name: 'Spree::Serviceables::Ship',
      foreign_key: :start_port_id
  end
end
