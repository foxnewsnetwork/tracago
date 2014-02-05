class Itps::Admins::InboundTransfersController < Itps::AdminBaseController
  def new
    _form_helper
  end

  def create
    _create_money_transfer!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _create_money_transfer!
    @money_transfer ||= _creative_form_helper.money_transfer
  end

  def _render_flash!
    flash[:success] = t(:transfer_successful_logged) if _create_success?
    flash[:error] = t(:transfer_failed) if _create_failed?
  end

  def _create_success?
    _creative_form_helper.create_success?
  end

  def _create_failed?
    _creative_form_helper.create_failed?
  end

  def _get_out_of_here!
    return redirect_to itps_admin_money_transfer_path(@money_transfer) if _create_success?
    render :new if _create_failed?
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _inbound_transfer_params
    end
  end

  def _inbound_transfer_params
    params.require(:inbound_transfers).permit *Itps::Admins::InboundTransfers::FormHelper::Fields
  end

  def _form_helper
    @form_helper ||= Itps::Admins::InboundTransfers::FormHelper.new
  end

end