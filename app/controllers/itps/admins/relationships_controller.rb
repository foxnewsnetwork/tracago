class Itps::Admins::RelationshipsController < Itps::AdminBaseController
  def destroy
    _destroy_relationship!
    _render_flash!
    _get_out_of_here!
  end
  private
  def _destroy_relationship!
    @destroy_result = _relationship.destroy
  end
  def _render_flash!
    flash[:success] = t(:successfully_unclaimed) if _destroy_success?
    flash[:error] = t(:cannot_unclaim) if _destroy_failed?
  end
  def _destroy_success?
    true == @destroy_result
  end
  def _destroy_failed?
    false == @destroy_result
  end
  def _get_out_of_here!
    redirect_to itps_admin_escrow_inbound_transfers_path(_escrow)
  end
  def _escrow
    @escrow ||= _relationship.escrow
  end
  def _relationship
    @relationship ||= Itps::MoneyTransfersEscrows.find params[:id]
  end
end