class Itps::Admins::MoneyTransfers::PutsController < Itps::AdminBaseController

  def edit
    _form_helper
  end

  def update
    _update_transfer!
    _render_flash!
    _get_out_of_here!
  end
  private
  def _update_transfer!
    @update_result = _updative_form_helper.update_transfer!
  end
  def _updative_form_helper
    _form_helper.tap do |f|
      f.attributes = _money_transfer_params
    end
  end
  def _money_transfer_params
    params.require(:money_transfers).permit(*Itps::Admins::MoneyTransfers::PutsFormHelper::Fields)
  end
  def _render_flash!
    flash[:success] = t(:successfully_updated) if _update_success?
    flash[:error] = t(:unable_to_update) if _update_failed?
  end
  def _update_success?
    true == @update_result
  end
  def _update_failed?
    false == @update_result
  end
  def _get_out_of_here!
    return redirect_to itps_admin_money_transfer_path(_money_transfer) if _update_success?
    render :edit
  end
  def _form_helper
    @form_helper ||= Itps::Admins::MoneyTransfers::PutsFormHelper.new _money_transfer
  end
  def _money_transfer
    @money_transfer ||= Itps::MoneyTransfer.find params[:id]
  end
end