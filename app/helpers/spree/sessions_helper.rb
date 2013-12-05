module Spree::SessionsHelper
  def correct_user_session?(user)
    user_signed_in? && current_user == user
  end

  def correct_shop_session?(shop)
    correct_user_session? shop.user
  end
end