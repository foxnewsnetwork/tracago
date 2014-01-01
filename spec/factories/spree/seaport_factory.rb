# == Schema Information
#
# Table name: spree_seaports
#
#  id         :integer          not null, primary key
#  port_code  :string(255)      not null
#  port_name  :string(255)
#  address_id :integer
#

class ChineseFactory::Seaport < ChineseFactory::Base
  attr_accessor :address

  def initialize
    @address = ChineseFactory::Address.mock
  end

  def belongs_to(thing)
    tap do |f|
      f.address = thing if thing.is_a? Spree::Address
    end
  end

  def attributes
    {
      port_name: Faker::Address.city,
      port_code: unique_port_code,
      address: address
    }
  end

  def unique_port_code
    $ChineseFactorySeaportCodeCount ||= 0
    $ChineseFactorySeaportCodeCount += 1
    throw "port code overflow error" if $ChineseFactorySeaportCodeCount >= 11881376
    $ChineseFactorySeaportCodeCount.to_alphabet.prepend_until('a') { |s| s.length >= 5 }
  end
end
