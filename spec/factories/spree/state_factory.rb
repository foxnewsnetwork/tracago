# == Schema Information
#
# Table name: spree_states
#
#  id                 :integer          not null, primary key
#  romanized_name     :string(255)
#  abbr               :string(255)
#  permalink          :string(255)      not null
#  local_presentation :string(255)
#  country_permalink  :string(255)
#  updated_at         :datetime
#

module ChineseFactory
  class State < Base
    class << self
      def mock
        belongs_to(Country.mock).create
      end

      def belongs_to(thing)
        new.belongs_to thing
      end
    end
    attr_accessor :country

    def belongs_to(thing)
      tap do |factory|
        factory.country = thing if thing.is_a? ::Spree::Country
      end
    end

    def attributes
      { 
        romanized_name: Faker::AddressUS.state,
        abbr: Faker::AddressUS.state_abbr,
        country: country
      }
    end

  end
end
