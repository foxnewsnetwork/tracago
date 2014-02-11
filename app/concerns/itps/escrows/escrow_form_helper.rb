class Itps::Escrows::EscrowFormHelper < Spree::FormHelperBase
  Fields = [
    :paying_company_name, 
    :paying_company_email, 
    :working_company_name, 
    :working_company_email,
    :drafted_by_paying,
    :dollar_amount
  ]

  attr_hash_accessor *Fields
  attr_accessor :attributes
  validates *Fields,
    presence: true
  validates :dollar_amount,
    numericality: true


  def escrow!
    Itps::Escrow.create! _escrow_params
  end

  private

  def _escrow_params
    {
      payment_party: _payment_party,
      service_party: _service_party,
      draft_party: _draft_party,
      dollar_amount: dollar_amount
    }
  end

  def _draft_party
    return _payment_party if _drafted_by_paying?
    _service_party
  end

  def _drafted_by_paying?
    drafted_by_paying.present?
  end

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