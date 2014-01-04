class Itps::Accounts::EscrowsController < Itps::BaseController
  before_filter :_filter_anonymous_user,
    :_filter_wrong_user,
    only: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, 
    with: :_try_anonymous_path

  def new
    _form_helper
  end

  def create
    _escrow!
    _setup_flash!
    _get_out_of_here!
  end

  private
  def _escrow!
    @escrow ||= _creative_form_helper.escrow! if _valid?
  end

  def _setup_flash!
    return flash[:notice] = t(:successfully_created) if _created?
    flash[:error] = t(:something_went_wrong)
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path @escrow.permalink if _created?
    render :new 
  end

  def _valid?
    _creative_form_helper.valid?
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _raw_escrow_params
      f.account = current_account
    end
  end

  def _raw_escrow_params
    params.require(:escrows).permit *Itps::Accounts::Escrows::EscrowFormHelper::Fields
  end

  def _created?
    @escrow.present? && @escrow.persisted?
  end

  def _form_helper
    @form_helper ||= Itps::Accounts::Escrows::EscrowFormHelper.new
  end

  def _account
    @account ||= Itps::Account.find params[:account_id]
  end

  def _filter_anonymous_user
    redirect_to itps_signin_path unless user_signed_in?
  end

  def _filter_wrong_user
    if _account != current_account
      flash[:notice] = t(:redirecting_to_correct_path)
      redirect_to new_itps_account_escrow_path current_account
    end
  end

  def _try_anonymous_path
    redirect_to new_itps_escrow_path
  end
end