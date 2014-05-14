class Itps::Buys::Internationals::EscrowInteractor

  attr_accessor :contract
  def escrow!
    _steps
    _agreement
    _escrow_parties
    _escrow.reload
  end

  private
  def _escrow_parties
    _sync_service_party
    _sync_payment_party
  end
  def _sync_service_party
    _escrow.payment_party.update company_name: _d[:buyer_company_name]
  end
  def _sync_payment_party
    _escrow.service_party.update company_name: _d[:seller_company_name]
  end
  def _agreement
    _escrow.payment_party_agree!
  end
  def _d
    @d ||= contract.draft.parsed_hash
  end
  def _escrow
    @escrow ||= _escrow_form_helper.escrow!
  end
  def _escrow_form_helper
    @escrow_form_helper ||= Itps::Accounts::Escrows::EscrowFormHelper.new.tap do |f|
      f.attributes = _escrow_attributes
      f.account = _buyer_account
    end
  end
  def _escrow_attributes
    {
      other_party_email: _d[:seller_email],
      other_party_company_name: _d[:seller_company_name],
      dollar_amount: contract.draft.total_cost_plus_escrow_fee,
      my_role: 'payment_party'
    }
  end
  def _buyer_account
    Itps::Account.find_by_email! _d[:buyer_email]
  end
  def _steps
    _seller_preloading_pictures_step if _preloading_pics?
    _buyer_funds_escrow_step
    _seller_weight_ticket_step if _weight_ticket?
    _seller_loading_pics_step if _loading_pics?
    _seller_bill_of_lading if _bill_of_lading?
    _seller_invoice_step if _invoice?
    _seller_packing_list if _packing_list?
  end

  def _preloading_pics?
    1 == _d[:preloading_pictures].to_i
  end
  def _weight_ticket?
    1 == _d[:weight_ticket].to_i
  end
  def _loading_pics?
    1 == _d[:loading_pictures].to_i
  end
  def _bill_of_lading?
    1 == _d[:bill_of_lading].to_i
  end
  def _packing_list?
    1 == _d[:packing_list].to_i
  end
  def _invoice?
    1 == _d[:invoice].to_i
  end

  def _step_interactor
    @step_interactor ||= Itps::Buys::Internationals::StepInteractor.new _escrow
  end

  def _seller_preloading_pictures_step
    _step_interactor.seller_preloading_pictures_step
  end

  def _buyer_funds_escrow_step
    _step_interactor.buyer_funds_escrow_step
  end

  def _seller_weight_ticket_step
    _step_interactor.seller_weight_ticket_step
  end

  def _seller_loading_pics_step
    _step_interactor.seller_loading_pics_step
  end

  def _seller_bill_of_lading
    _step_interactor.seller_bill_of_lading
  end

  def _seller_invoice_step
    _step_interactor.seller_invoice_step
  end

  def _seller_packing_list
    _step_interactor.seller_packing_list
  end

end