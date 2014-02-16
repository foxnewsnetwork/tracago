class Itps::Admins::InboundTransfers::EscrowsController < Itps::AdminBaseController
  before_filter :_filter_inbound_outbound
  def index
    _inbound_transfer
    _escrows
  end
  private
  def _filter_inbound_outbound
    redirect_to itps_admin_outbound_transfer_escrows_path _inbound_transfer unless _inbound_transfer.inbound?
  end
  def _inbound_transfer
    @inbound_transfer ||= Itps::MoneyTransfer.find params[:inbound_transfer_id]
  end
  def _escrows
    return _all_escrows if 'all' == params[:show].to_s
    _unclaimed_escrows
  end

  def _all_escrows
    @escrows ||= Itps::Escrow.order('updated_at desc').page(params[:page]).per(params[:per_page])
  end

  def _unclaimed_escrows
    @escrows ||= Itps::Escrow.unclaimed.order('updated_at desc').page(params[:page]).per(params[:per_page])
  end
end