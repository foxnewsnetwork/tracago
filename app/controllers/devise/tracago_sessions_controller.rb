class Devise::TracagoSessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)
    _setup_appropriate_flash
    sign_in(resource_name, resource) if _successful_login?
    redirect_to _return_path
  end

  private
  def after_sign_out_path_for(resource_name)
    params[:back] || root_path
  end

  def _setup_appropriate_flash
    set_flash_message(:notice, :signed_in)      if _successful_login?
    set_flash_message(:error, :no_such_email)   if _no_such_email?
    set_flash_message(:error, :incorrect_password) if _wrong_password?
  end

  def _no_such_email?
    _failed_login? && Spree::User.find_by_email(params[:user][:email]).blank?
  end

  def _wrong_password?
    _failed_login? && Spree::User.find_by_email(params[:user][:email]).present?
  end

  def _failed_login?
    !_successful_login?
  end

  def _successful_login?
    @login_result ||= resource.present? && is_navigational_format?
  end

  def _back_path
    params[:user][:back]
  end

  def _go_back?
    params[:user].present? && params[:user][:back].present?
  end

  def _login_path(*stuff)
    return itps_login_path(*stuff) if _itps_origin?
    return login_path(*stuff)
  end

  def _itps_origin?
    'itps' == params[:user][:origin].to_s
  end

  def _root_path
    return itps_root_path if _itps_origin?
    return root_path
  end

  def _return_path
    return _login_path(back: _back_path) if resource.blank?
    return _back_path if _go_back?
    return request.referer if request.referer.present?
    return _root_path
  end
end