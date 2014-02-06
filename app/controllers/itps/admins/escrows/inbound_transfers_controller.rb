class Itps::Admins::Escrows::InboundTransfersController < Itps::AdminBaseController

  def index
    _escrow
    _inbound_transfers
  end

  private
  def _escrow
    @escrow ||= Itps::Escrow.find params[:escrow_id]
  end

  def _inbound_transfers
    return _unclaimed_transfers if 'unclaimed' == params[:show].to_s
    return _claimed_transfers
  end

  def _unclaimed_transfers
    @inbound_transfers ||= Itps::MoneyTransfer.unclaimed.page(params[:page]).per(params[:per_page])
  end

  def _claimed_transfers
    @inbound_transfers ||= _escrow.money_transfers.page(params[:page]).per(params[:per_page])
  end
end