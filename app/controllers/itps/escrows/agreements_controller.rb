class Itps::Escrows::AgreementsController < Itps::BaseController
  before_filter :_filter_inappropriate_users
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
  def _filter_inappropriate_users
    unless _relevant_party? || _has_secret_key?
      redirect_to itps_escrow_path _escrow.permalink
      flash[:error] = t(:you_are_not_among_the_relevant_party)
    end
  end

  def _relevant_party?
    _payment_party? || _service_party?
  end

  def _payment_party?
    _escrow.matches_payment_account? current_account
  end

  def _service_party?
    _escrow.matches_service_account? current_account
  end

  def _has_secret_key?
    params[:secret_key].present?
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink params[:escrow_id]
  end

  def _escrow_ready!
    @agreed_party ||= _escrow.secret_key_party_agree! _secret_key if _in_position_to_agree?
  end

  def _agreement_successful?
    @agreed_party.present?
  end

  def _secret_key
    params[:escrows].try(:[], :secret_key) || 
      _escrow.secret_key_for_account(current_account)
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
    return render :new
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