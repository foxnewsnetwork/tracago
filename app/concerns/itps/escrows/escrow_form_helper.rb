class Itps::Escrows::EscrowFormHelper < Spree::FormHelperBase
  Fields = [:paying_company_name, :paying_company_email, :working_company_name, :working_company_email]

  attr_hash_accessor *Fields
  attr_accessor :attributes
  validates :paying_company_name, 
    :working_company_name,
    :paying_company_email,
    :working_company_email,
    presence: true

  def escrow!
    Itps::Escrow.create! payment_party: _payment_party,
      service_party: _service_party
  end

  private
  def _service_party
    @service_party ||= Itps::Party.find_by_email(working_company_email)
    @service_party ||= Itps::Party.create email: working_company_email, 
      company_name: working_company_name
  end

  def _payment_party
    @payment_party ||= Itps::Party.find_by_email(paying_company_email)
    @payment_party ||= Itps::Party.create email: paying_company_email,
      company_name: paying_company_name
  end
end