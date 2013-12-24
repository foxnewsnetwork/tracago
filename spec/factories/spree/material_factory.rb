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