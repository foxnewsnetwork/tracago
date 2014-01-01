class Itps::Accounts::RegistrationFormHelper < Spree::FormHelperBase
  class UniqueEmailValidator < ActiveModel::Validator
    def validate(record)
      if Itps::Account.find_by_email(record.email).present?
        record.errors.add :email, :not_unique
      end
    end
  end
  Fields = [
    :company_name,
    :email,
    :password,
    :password_confirmation,
    :back
  ]

  validates :email,
    :password,
    :password_confirmation,
    :company_name,
    presence: true
  validates :email,
    format: { with: Devise.email_regexp }
  validates :password,
    confirmation: true,
    length: { in: 2..128 }
  validates_with UniqueEmailValidator

  attr_hash_accessor *Fields
  attr_accessor :attributes

  def party!
    _party!
  end

  def signup_params
    _account_params
  end

  private
  def _account_params
    attributes.permit :email, :password, :password_confirmation
  end

  def _party_params
    attributes.permit :email, :company_name
  end

  def _party
    @party ||= Itps::Party.create! _party_params
  end

end