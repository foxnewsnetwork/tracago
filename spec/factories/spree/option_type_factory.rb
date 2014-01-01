# == Schema Information
#
# Table name: spree_option_types
#
#  id           :integer          not null, primary key
#  name         :string(100)
#  presentation :string(100)
#  position     :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

module ChineseFactory
  class OptionType
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        name: Faker::Name.first_name,
        presentation: Faker::Name.first_name,
        position: rand(344) 
      }
    end

    def create
      ::Spree::OptionType.create attributes
    end
  end
end
