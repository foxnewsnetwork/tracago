class Itps::Accounts::SessionsController < Devise::SessionsController
  layout 'itps/layouts/application'
  include Itps::BaseHelper
  def create
    self.resource = warden.authenticate auth_options
    _setup_appropriate_flash
    sign_in(resource_name, resource) if _successful_login?
    redirect_to _return_path
  end

  def new
    _redirect_to itps_account_path current_itps_account if itps_account_signed_in?
  end

  private
  def _setup_appropriate_flash
    set_flash_message(:notice, :signed_in)         if _successful_login?
    set_flash_message(:error, :no_such_email)      if _no_such_email?
    set_flash_message(:error, :incorrect_password) if _wrong_password?
  end

  def _no_such_email?
    _failed_login? && Itps::Account.find_by_email(params[:account][:email]).blank?
  end

  def _wrong_password?
    _failed_login? && Itps::Account.find_by_email(params[:account][:email]).present?
  end

  def _failed_login?
    !_successful_login?
  end

  def _successful_login?
    @login_result ||= resource.present? && is_navigational_format?
  end

  def _back_path
    params[:account][:back]
  end

  def _go_back?
    params[:account].present? && params[:account][:back].present?
  end

  def _return_path
    return new_itps_account_session_path(back: _back_path) if resource.blank?
    return _back_path if _go_back?
    return request.referer if request.referer.present?
    return itps_path
  end
end