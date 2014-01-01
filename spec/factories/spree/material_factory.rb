# == Schema Information
#
# Table name: spree_materials
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  permalink   :string(255)      not null
#  deleted_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

module ChineseFactory
  class Material
    class << self
      def mock
        new.create
      end
    end

    def attributes
      {
        name: Faker::Name.first_name,
        description: Faker::Lorem.paragraph
      }
    end

    def create
      ::Spree::Material.create! attributes
    end
  end
end
