# == Schema Information
#
# Table name: spree_shops
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  deleted_at :datetime
#  email      :string(255)
#  address_id :integer
#  name       :string(255)      not null
#  permalink  :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

module ChineseFactory
  class Shop
    attr_accessor :user

    def self.belongs_to(user)
      new.belongs_to user
    end

    def self.mock
      belongs_to(User.mock).create
    end

    def belongs_to(thing)
      tap do |factory|
        factory.user = thing if thing.is_a? ::Spree::User
      end
    end

    def attributes
      {
        name: Faker::Company.name + Time.now.to_f.to_s,
        user: user
      }
    end

    def create
      ::Spree::Shop.create attributes
    end
  end
end
