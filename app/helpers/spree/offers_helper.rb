module Spree::OffersHelper

  def relevant_user?
    seller_user? || buyer_user?
  end

  def seller_user?
    user_signed_in? && (current_user.shop == @offer.seller)
  end

  def buyer_user?
    user_signed_in? && (current_user.shop == @offer.buyer)
  end
end