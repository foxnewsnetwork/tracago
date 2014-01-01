# == Schema Information
#
# Table name: spree_stockpiles
#
#  id                 :integer          not null, primary key
#  material_id        :integer
#  address_id         :integer
#  pounds_on_hand     :integer
#  cost_usd_per_pound :decimal(10, 5)
#  deleted_at         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  notes              :text
#

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
