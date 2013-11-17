module Spree::UserFilterHelper
  def filter_anonymous_users
    unless user_signed_in?
      redirect_to login_path back: request.fullpath
      flash[:error] = Spree.t(:you_must_be_signed_in)
    end
  end

  def filter_incorrect_users
    unless user_signed_in? && _correct_shops.include?(current_shop)
      redirect_to root_path
      flash[:error] = Spree.t(:sorry_you_are_not_the_right_user)
    end
  end

  def current_shop
    current_user.try :shop
  end

  private

  def _correct_shops
    [_correct_shop].reject(&:blank?)
  end

end