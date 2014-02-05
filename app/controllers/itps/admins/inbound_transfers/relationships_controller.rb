class Itps::Admins::InboundTransfers::RelationshipsController < Itps::AdminBaseController
  def create
    _relationship
    _render_flash!
    _get_out_of_here!
  end

  private
  def _relationship
    @relationship ||= _money_transfer.apply_to _escrow
  end

  def _money_transfer 
    @money_transfer ||= Itps::MoneyTransfer.find params[:inbound_transfer_id]
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_id! _escrow_params[:escrow_id]
  end

  def _render_flash!
    flash[:error] = t(:cannot_apply_for_some_reason) if _create_failed?
    flash[:success] = t(:successfully_applied) if _create_success?
  end

  def _create_success?
    _relationship.present? && _relationship.persisted?
  end

  def _create_failed?
    !_create_success?
  end

  def _get_out_of_here!
    redirect_to itps_admin_inbound_transfer_escrows_path(_money_transfer)
  end

  def _escrow_params
    params.require(:relationship).permit(:escrow_id)
  end

end