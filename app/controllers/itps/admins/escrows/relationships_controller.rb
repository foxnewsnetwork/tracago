class Itps::Admins::Escrows::RelationshipsController < Itps::Admins::InboundTransfers::RelationshipsController

  private
  def _money_transfer 
    @money_transfer ||= Itps::MoneyTransfer.find _inbound_transfer_params[:inbound_transfer_id]
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_id! params[:escrow_id]
  end

  def _inbound_transfer_params
    params.require(:relationship).permit(:inbound_transfer_id)
  end

  def _get_out_of_here!
    redirect_to itps_admin_escrow_inbound_transfers_path(_escrow)
  end
end