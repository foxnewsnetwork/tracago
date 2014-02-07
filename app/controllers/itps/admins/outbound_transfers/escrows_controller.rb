class Itps::Admins::OutboundTransfers::EscrowsController < Itps::Admins::InboundTransfers::EscrowsController
  def index
    _outbound_transfer
    _escrows
  end
  private
  def _filter_inbound_outbound
    redirect_to itps_admin_inbound_transfer_escrows_path _outbound_transfer if _outbound_transfer.inbound?
  end

  def _outbound_transfer
    @outbound_transfer ||= Itps::MoneyTransfer.find params[:outbound_transfer_id]
  end
end