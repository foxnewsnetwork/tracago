class Itps::Admins::MoneyTransfers::DeletesController < Itps::AdminBaseController
  def destroy
    _destroy_transfer!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _destroy_transfer!
    @destroy_result = _transfer.attempt_destroy
  end
  def _render_flash!
    flash[:success] = t(:successfully_cleared) if _destroy_success?
    flash[:error] = t(:unable_to_destroy) if _destroy_failed?
  end
  def _get_out_of_here!
    return redirect_to itps_admin_money_transfers_path if _destroy_success?
    return redirect_to itps_admin_money_transfer_path(_transfer) if _destroy_failed?
  end
  def _destroy_success?
    true == @destroy_result
  end
  def _destroy_failed?
    false == @destroy_result
  end
  def _transfer
    @transfer ||= Itps::MoneyTransfer.find params[:id]
  end
end