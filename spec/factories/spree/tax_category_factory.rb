module ChineseFactory
  class TaxCategory
    def self.mock
      new.create
    end

    def attributes
      {
        name: "Tax via #{Faker::Name.name}"
      }
    end

    def create
      ::Spree::TaxCategory.create! attributes
    end
  end
end