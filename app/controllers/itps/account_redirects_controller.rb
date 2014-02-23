class Itps::AccountRedirectsController < Itps::BaseController
  before_filter :_filter_logged_in_user

  def show; end

  private
  def _filter_logged_in_user
    if user_signed_in?
      out = _out_path || itps_account_path(current_account)
      redirect_to out
    end
  end
  def _out_path
    params[:back]
  end
end