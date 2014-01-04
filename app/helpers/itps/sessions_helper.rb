module Itps::SessionsHelper
  def current_account
    @current_account ||= Itps::Account.find_by_email current_user.try(:email) if user_signed_in?
  end
end