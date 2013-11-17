module Spree
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable

    validates_uniqueness_of :email,
      :case_sensitive => false
    validates_format_of :email, 
      :with  => Devise.email_regexp
    validates_presence_of :password_confirmation, :if => :encrypted_password_changed?
    validates_presence_of :password, on: :create
    validates_confirmation_of :password, on: :create

    has_one :shop, class_name: 'Spree::Shop'
    has_many :listings, through: :shop

    has_many :preferences,
      dependent: :destroy

    scope :registered, -> { where("#{users_table_name}.email NOT LIKE ?", "%@example.net") }

    class << self
      def anonymous!
        token = User.generate_token(:persistence_token)
        User.create(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
      end
    end

    def anonymous?
      email =~ /@example.net$/ ? true : false
    end

    def shop_id
      shop.try(:id)
    end
  end
end