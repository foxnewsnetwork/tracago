# == Schema Information
#
# Table name: spree_countries
#
#  id                 :integer          not null, primary key
#  iso                :string(255)
#  iso3               :string(255)
#  permalink          :string(255)      not null
#  romanized_name     :string(255)
#  local_presentation :string(255)
#  numcode            :string(255)
#  updated_at         :datetime
#

module ChineseFactory
  class Country
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        romanized_name: Faker::Address.country,
        iso: Faker::Address.country.slice(0,2).upcase,
        iso3: Faker::Address.country.slice(0,3).upcase,
        numcode: rand(234)
      }
    end

    def create
      ::Spree::Country.create! attributes
    end
  end
end
