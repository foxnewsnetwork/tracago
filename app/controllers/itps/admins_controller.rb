class Itps::AdminsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  def show
    _account
  end

  private
  def _account
    @account ||= Itps::Account.find params[:id]
  end
end