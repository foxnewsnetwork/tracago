module Spree::SessionsHelper
  def correct_user_session?(user)
    user_signed_in? && current_user == user
  end
end