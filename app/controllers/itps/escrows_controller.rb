class Itps::EscrowsController < Itps::BaseController
  before_filter :_filter_logged_in_users,
    only: [:new, :create]

  before_filter :_filter_anonymous_keyless_users,
    only: [:show]

  before_filter :_redirect_to_login, 
    :_redirect_to_login_new,
    only: [:new]

  def show
    _escrow
  end

  def payment_instructions
    _escrow
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
  def _redirect_to_login
    redirect_to itps_login_path(back: new_itps_escrow_path) unless user_signed_in?
  end
  def _redirect_to_login_new
    redirect_to new_itps_account_escrow_path(current_account) if user_signed_in?
  end
  def _filter_anonymous_keyless_users
    if !user_signed_in? && _incorrect_secret_key?
      flash[:error] = t(:please_sign_in_to_manage_your_contract_escrow)
      redirect_to itps_login_path back: request.fullpath
    end
  end

  def _incorrect_secret_key?
    !_correct_secret_key?
  end

  def _correct_secret_key?
    params[:secret_key].present? && _escrow.unclaimed_secret_keys.include?(params[:secret_key])
  end

  def _filter_logged_in_users
    return unless user_signed_in?
    redirect_to new_itps_account_escrow_path current_account
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if _existing?
    return render :new if _invalid?
  end

  def _creative_form_helper
    _form_helper.tap do |f| 
      f.attributes = _raw_escrow_params
    end
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
    @escrow ||= Itps::Escrow.find_by_permalink! params[:id]
  end
end