class Itps::Admins::MoneyTransfersController < Itps::AdminBaseController
  def show
    _money_transfer
  end

  def index
    _money_transfers
  end

  private
  def _money_transfer
    @money_transfer ||= Itps::MoneyTransfer.find params[:id]
  end

  def _money_transfers
    @money_transfers ||= Itps::MoneyTransfer.page(params[:page].to_i).per(params[:per] || 10)
  end
  
end