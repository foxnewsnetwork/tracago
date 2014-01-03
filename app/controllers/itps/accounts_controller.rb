class Itps::AccountsController < Itps::BaseController
  def show
    _account
  end

  private
  def _account
    @account ||= Itps::Account.find params[:id]
  end
end