class Spree::Users::Devise::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource sign_up_params
    _setup_flash_message!
    _consider_signing_up_or_fail!
    _get_out! resource
  end

  private

  def _user_invalid?
    resource.is_a?(Spree::User) && !resource.valid?
  end

  def _user_valid?
    resource.is_a?(Spree::User) && resource.valid?
  end

  def _get_out!(user)
    return redirect_to signup_path(_back_params) if _user_invalid?
    return redirect_to _return_path if _user_valid? && _return_path.present?
    return redirect_to user_path user if _user_valid?
  end

  def _consider_signing_up_or_fail!
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

  def _setup_flash_message!
    set_flash_message :notice, :signed_up if _successful_signup?
    set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if _sorta_successful_signup?
    set_flash_message :error, :email_has_already_been_userd_or_mistyped_password if _unsuccessful_signup?
  end

  def _successfully_saved?
    @successfully_saved ||= resource.save
  end

  def _activated_for_auth?
    @activated_for_auth ||= _successfully_saved? && resource.active_for_authentication?
  end

  def _navigational_format?
    @_navigational_format ||= _successfully_saved? && is_navigational_format?
  end

  def _return_path
    _back_params[:back] || request.referer
  end

  def _back_params
    params.require(:user).permit(:back, :email)
  end

end