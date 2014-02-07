class Itps::Admins::OutboundTransfersController < Itps::Admins::InboundTransfersController
  private
  def _outbound_transfer_params
    params.require(:outbound_transfers).permit *Itps::Admins::InboundTransfers::FormHelper::Fields
  end

  def _form_helper
    @form_helper ||= Itps::Admins::OutboundTransfers::FormHelper.new
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _outbound_transfer_params
    end
  end

end