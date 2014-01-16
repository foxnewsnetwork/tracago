class Itps::AdminsController < Itps::AdminBaseController
  
  def show
    _account
  end

  private
  def _account
    @account ||= Itps::Account.find params[:id]
  end
end