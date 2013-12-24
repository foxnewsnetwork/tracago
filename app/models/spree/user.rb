# == Schema Information
#
# Table name: spree_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)
#  password_salt          :string(255)
#  login                  :string(255)
#  ship_address_id        :integer
#  bill_address_id        :integer
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  remember_token         :string(255)
#  persistence_token      :string(255)
#  single_access_token    :string(255)
#  perishable_token       :string(255)
#  sign_in_count          :integer          default(0), not null
#  failed_attempts        :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  last_request_at        :datetime
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  openid_identifier      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  shop_id                :integer
#

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
    @my_default_shop ||= Spree::Shop.find_by_user_id(id) ||
      Spree::Shop.find_or_create_by(
        name: "Default Null Shop of #{id}", 
        email: email, 
        user_id: id)
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
