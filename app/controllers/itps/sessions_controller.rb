class Itps::SessionsController < Itps::BaseController

  def new
    redirect_to itps_account_path current_user if user_signed_in?
  end
end