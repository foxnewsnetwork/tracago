class Itps::EscrowsController < Itps::BaseController
  def show
    _escrow
  end

  def tos
    _escrow
  end

  def ready
    _escrow_ready!
    _render_flash_ready!
    _get_out_of_here_ready!
    _dispatch_email!
  end

  def edit
    _editive_form_helper
  end

  def update
    _update_escrow!
    _render_update_flash!
    _get_out_of_here_update!
  end

  def new
    _form_helper
  end

  def create
    _escrow!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _escrow_ready!
    @result ||= _escrow.draft_party_agree! if _ready_params[:agree].present?
  end

  def _ready_params
    params.require(:escrow).permit(:agree)
  end

  def _render_flash_ready!
    flash.now[:error] = t(:you_must_consent_to_the_terms_of_service) unless @result
    flash[:success] = t(:contract_ready) if @result
  end

  def _get_out_of_here_ready!
    return redirect_to itps_escrow_path _escrow if @result
    return render :tos
  end

  def _dispatch_emails!
    _email_helper.dispatch! if @result
  end

  def _email_helper
    @email_helper ||= Itps::Escrows::EscrowEmailHelper.new
  end

  def _get_out_of_here_update!
    return redirect_to itps_escrow_path(_escrow.permalink) if _valid?
    return render :edit if _invalid?
  end

  def _render_update_flash!
    flash.now[:error] = t(:unable_to_update) if _invalid?
    flash[:notice] = t(:update_successful) if _valid?
  end

  def _update_escrow!
    _updative_form_helper.update_escrow!
  end

  def _updative_form_helper
    _editive_form_helper
    _creative_form_helper
  end

  def _editive_form_helper
    _form_helper.tap { |f| f.slug_in_escrow _escrow }
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if _existing?
    return render :new if _invalid?
  end

  def _creative_form_helper
    _form_helper.tap { |f| f.attributes = _raw_escrow_params }
  end

  def _form_helper
    @form_helper ||= Itps::Escrows::EscrowFormHelper.new
  end

  def _raw_escrow_params
    params.require(:escrows).permit *Itps::Escrows::EscrowFormHelper::Fields
  end

  def _escrow!
    @escrow ||= _creative_form_helper.escrow! if _valid?
  end

  def _render_flash!
    flash.now[:error] = t(:terrible_input_data) if _invalid?
    flash[:notice] = t(:escrow_opened) if _valid?
  end

  def _existing?
    _escrow.try :valid?
  end

  def _invalid?
    !_valid?
  end

  def _valid?
    _creative_form_helper.valid?
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink params[:id]
  end
end