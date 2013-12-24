module ChineseFactory
  class User
    class << self
      def mock
        new.create
      end

      def attributes
        new.attributes
      end
    end

    def attributes
      {
        email: Faker::Internet.email,
        password: "asdf123",
        password_confirmation: "asdf123"
      }
    end

    def create
      ::Spree::User.create! attributes
    end
  end
end