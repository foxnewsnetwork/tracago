module ChineseFactory
  class Stockpile
    class << self
      def belongs_to(thing)
        new.belongs_to thing
      end

      def mock
        belongs_to(Material.mock).belongs_to(Address.mock).create
      end
    end
    attr_accessor :material, :address

    def belongs_to(thing)
      tap do |factory|
        factory.material = thing if thing.is_a? ::Spree::Material
        factory.address = thing if thing.is_a? ::Spree::Address
      end
    end

    def attributes
      {
        material: material,
        address: address,
        pounds_on_hand: rand(294795),
        cost_usd_per_pound: rand(324)
      }
    end

    def create
      ::Spree::Stockpile.create! attributes
    end
  end
end