class Itps::Parties::AccountsController < Itps::BaseController
  include ::Devise::Controllers::Helpers
  before_filter :_filter_claimed_accounts,
    :_filter_logged_in_users
  def new
    _form_helper
  end

  def create
    _build_and_login_account!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _build_and_login_account!
    _login_account! if _build_account!
  end

  def _login_account!
    sign_in _user
  end

  def _user
    @user ||= Spree::User.find_by_email _account.email
  end

  def _account
    @account
  end

  def _render_flash!
    return flash[:success] = t(:account_created_and_signed_in) if user_signed_in?
    return flash[:error] = t(:account_failed_to_build) if _build_failed?
    return flash[:error] = t(:failed_to_login_to_built_account) if _login_failed?
  end

  def _build_failed?
    _account.present? && _account.persisted?
  end

  def _build_account!
    @account ||= _creative_form_helper.account!
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _raw_account_params
    end
  end

  def _form_helper
    @form_helper ||= Itps::Parties::Accounts::AccountFormHelper.new.tap { |f| f.party = _party }
  end

  def _raw_account_params
    params.require(:accounts).permit(:password, :password_confirmation)
  end

  def _login_failed?
    !user_signed_in?
  end

  def _get_out_of_here!
    return redirect_to _return_path if user_signed_in?
    render :new
  end

  def _filter_claimed_accounts
    if _account_claimed?
      redirect_to _return_path
      flash[:error] = t(:that_account_already_is_associated_with_a_party)
    end
  end

  def _account_claimed?
    _party.account.present?
  end

  def _return_path
    return params[:back] if params[:back].present?
    return params[:accounts][:back] if params[:accounts].try(:[], :back).present?
    return itps_account_path current_account if current_account.present?
    return itps_path
  end

  def _filter_logged_in_users
    if user_signed_in?
      redirect_to _return_path
      flash[:notice] = t(:you_already_have_an_account)
    end
  end

  def _party
    @party ||= Itps::Party.find_by_permalink_or_id! params[:party_id]
  end
end