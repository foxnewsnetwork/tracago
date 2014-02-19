class Itps::RegistrationsController < Itps::BaseController
  before_filter :_filter_logged_in_user
  def new
    _form_helper
  end

  def create
    _build_and_login_account!
    _setup_flash!
    _get_out_of_here!
    _dispatch_email!
  end

  private
  def _filter_logged_in_user
    if user_signed_in?
      redirect_to itps_account_path current_account.permalink
    end
  end
  def _form_helper
    @form_helper ||= Itps::Accounts::RegistrationFormHelper.new
  end

  def _build_and_login_account!
    if _valid?
      _build_account!
      _login_account!
    end
  end

  def _login_account!
    return sign_up(resource_name, resource) if _successful_signup?
    return expire_session_data_after_sign_in! if _sorta_successful_signup?
    return clean_up_passwords resource if _unsuccessful_signup?
  end

  def _unsuccessful_signup?
    !_successfully_saved?
  end

  def _successful_signup?
    _navigational_format? && _activated_for_auth?
  end

  def _sorta_successful_signup?
    _navigational_format? && !_activated_for_auth?
  end

  def _activated_for_auth?
    @activated_for_auth ||= _successfully_saved? && resource.active_for_authentication?
  end

  def _build_account!
    build_resource _creative_form_helper.signup_params
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _account_params
    end
  end

  def _setup_flash!
    set_flash_message :notice, :signed_up if _successful_signup?
    set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if _sorta_successful_signup?
    set_flash_message :error, :email_has_already_been_userd_or_mistyped_password if _unsuccessful_signup?
  end

  def _valid?
    _creative_form_helper.valid?
  end

  def _invalid?
    !_valid?
  end

  def _navigational_format?
    @_navigational_format ||= _successfully_saved? && is_navigational_format?
  end

  def _successfully_saved?
    @successfully_saved ||= _valid? && resource.save
  end

  def _get_out_of_here!
    return render :new if _invalid?
    return redirect_to _return_path if _valid?
  end

  def _return_path
    return _back_path if _go_back?
    return request.referer if request.referer.present?
    return itps_account_path _account if _valid?
    return itps_path
  end

  def _back_path
    params[:account][:back]
  end

  def _go_back?
    params[:account].present? && params[:account][:back].present?
  end

  def _dispatch_email!

  end

  def _account_params
    params.require(:accounts).permit *Itps::Accounts::RegistrationFormHelper::Fields
  end

end