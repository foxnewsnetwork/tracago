module ChineseFactory
  class User

    def self.mock
      new.create
    end

    def attributes
      {
        email: Faker::Internet.email,
        password: "asdf123"
      }
    end

    def create
      ::Spree::User.create attributes
    end
  end
end