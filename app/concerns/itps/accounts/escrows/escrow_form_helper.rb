class Itps::Accounts::Escrows::EscrowFormHelper < Spree::FormHelperBase
  Fields = [
    :other_party_email,
    :other_party_company_name,
    :my_role
  ]
  attr_hash_accessor *Fields
  attr_accessor :attributes, :account

  validates *Fields,
    :account,
    presence: true


  def escrow!
    @escrow ||= Itps::Escrow.create! service_party: _service_party,
      payment_party: _payment_party,
      draft_party: _draft_party
  end

  def created?
    @escrow.try :persisted?
  end

  private
  def _service_party
    return _other_party if _i_will_pay?
    return _this_party
  end

  def _other_party
    @other_party ||= Itps::Party.find_by_email other_party_email
    @other_party ||= Itps::Party.create email: other_party_email,
      company_name: other_party_company_name
  end

  def _this_party
    @this_party ||= @account.party
  end

  def _payment_party
    return _this_party if _i_will_pay?
    return _other_party
  end

  def _i_will_pay?
    'payment_party' == my_role.to_s
  end

  def _draft_party
    _this_party
  end

end