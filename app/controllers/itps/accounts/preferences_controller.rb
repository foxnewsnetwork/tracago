class Itps::Accounts::PreferencesController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  def index
    _account
  end
  private
  def _correct_account
    [_account]
  end

  def _account
    @account ||= Itps::Account.find params[:account_id]
  end
end