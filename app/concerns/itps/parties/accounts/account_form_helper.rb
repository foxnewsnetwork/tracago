class Itps::Parties::Accounts::AccountFormHelper < Spree::FormHelperBase
  Fields = [:password, :password_confirmation]

  attr_hash_accessor *Fields
  attr_accessor :attributes, :party

  validates *Fields,
    presence: true
  validates :password,
    confirmation: true,
    length: 2..128

  def account!
    if valid?
      u = Spree::User.create! _account_params 
      Itps::Account.find u.id
    end
  end

  private
  def _account_params
    attributes.merge email: party.email
  end
end