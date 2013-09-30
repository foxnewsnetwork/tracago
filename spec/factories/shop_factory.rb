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
        name: Faker::Company.name,
        user: user
      }
    end

    def create
      ::Spree::Shop.create attributes
    end
  end
end