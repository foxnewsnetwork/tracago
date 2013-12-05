class Spree::User < ActiveRecord::Base
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

  belongs_to :shop, 
    class_name: 'Spree::Shop'
  has_many :listings, through: :shop

  has_many :preferences,
    dependent: :destroy

  scope :registered, 
    -> { where("#{users_table_name}.email NOT LIKE ?", "%@example.net") }

  class << self
    def anonymous!
      token = User.generate_token(:persistence_token)
      User.create(
        email: "#{token}@example.net", 
        password: token, 
        password_confirmation: token, 
        persistence_token: token)
    end
  end

  def my_default_shop
    @my_default_shop ||= Spree::Shop.find_or_create_by name: "Default Null Shop of #{id}", 
      email: email, 
      user_id: id
  end

  def shop_with_default_shop
    shop_without_default_shop || my_default_shop
  end
  alias_method_chain :shop, :default_shop

  def anonymous?
    email =~ /@example.net$/ ? true : false
  end

  def shop_id
    shop.try(:id)
  end
end
