module Itps::SessionsHelper
  def current_account
    @current_account ||= Itps::Account.find_by_email current_user.try(:email) if user_signed_in?
  end

  def correct_account?(account)
    return false if current_account.blank? || account.blank?
    current_account == account
  end

  def filter_anonymous_account
    unless user_signed_in?
      redirect_to itps_login_path back: request.fullpath
      flash[:error] = Spree.t(:you_must_be_signed_in)
    end
  end

  def filter_wrong_account
    unless current_account.present? && _correct_accounts.reject(&:blank?).include?(current_account)
      redirect_to itps_path 
      flash[:error] = Spree.t(:you_are_not_allowed_access_to_that_page)
    end
  end

  private
  def _correct_accounts
    []
  end
end