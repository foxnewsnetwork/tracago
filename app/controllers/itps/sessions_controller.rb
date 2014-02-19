class Itps::SessionsController < Devise::SessionsController
  include Itps::BaseHelper
  include Itps::SessionsHelper
  layout 'itps/layouts/application'

  def new
    redirect_to itps_account_path current_user if user_signed_in?
  end
end