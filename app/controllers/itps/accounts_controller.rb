class Itps::AccountsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  def show
    _account
  end

  private
  def _correct_accounts
    [_account]
  end
  def _account
    @account ||= Itps::Account.find_by_id_or_permalink! params[:id]
  end
end