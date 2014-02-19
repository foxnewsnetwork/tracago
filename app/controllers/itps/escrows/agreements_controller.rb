class Itps::Escrows::AgreementsController < Itps::BaseController
  before_filter :_filter_inappropriate_users  
  before_filter :_filter_already_agreed_account, only: [:create]

  def new
    _escrow
  end

  def create
    _escrow_ready!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end

  private
  def _filter_already_agreed_account
    if _escrow.already_agreed? current_account.party
      redirect_to itps_escrow_path _escrow.permalink
      flash[:notice] = t(:you_have_already_agreed_to_the_contract)
    end
  end

  def _filter_inappropriate_users
    unless _relevant_party?
      redirect_to itps_escrow_path _escrow.permalink
      flash[:error] = t(:you_are_not_among_the_relevant_party)
    end
  end

  def _relevant_party?
    current_account.try(:admin?) || _payment_party? || _service_party?
  end

  def _payment_party?
    _escrow.matches_payment_account? current_account
  end

  def _service_party?
    _escrow.matches_service_account? current_account
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink params[:escrow_id]
  end

  def _escrow_ready!
    @agreed_party ||= _escrow.account_party_agree! current_account if _in_position_to_agree?
  end

  def _agreement_successful?
    @agreed_party.is_a? Itps::Party
  end

  def _in_position_to_agree?
    _ready_params[:agree].present?
  end

  def _ready_params
    params.require(:escrows).permit(:agree)
  end

  def _render_flash!
    flash.now[:error] = t(:you_must_consent_to_the_terms_of_service) unless _agreement_successful?
    flash[:success] = t(:contract_ready) if _agreement_successful?
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path _escrow.permalink if _agreement_successful?
    return redirect_to new_itps_escrow_agreement_path _escrow.permalink
  end

  def _dispatch_emails!
    _email_helper.inform_remaining_party_contract_is_ready! if _only_one_side_has_agreed?
    _email_helper.inform_both_parties_of_mutual_agreement! if _both_sides_has_agreed?
  end

  def _only_one_side_has_agreed?
    _escrow.single_side_locked?
  end

  def _both_sides_has_agreed?
    _escrow.opened?
  end

  def _email_helper
    @email_helper ||= Itps::Escrows::EscrowEmailHelper.new _escrow
  end

end