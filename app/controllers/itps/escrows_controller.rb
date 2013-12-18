class Itps::EscrowsController < Itps::BaseController
  def show
    _escrow
  end

  def new
    _form_helper
  end

  def create
    _escrow!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if _existing?
    return render :new if _invalid?
  end

  def _creative_form_helper
    _form_helper.tap { |f| f.attributes = _raw_escrow_params }
  end

  def _form_helper
    @form_helper ||= Itps::Escrows::EscrowFormHelper.new
  end

  def _raw_escrow_params
    params.require(:escrows).permit *Itps::Escrows::EscrowFormHelper::Fields
  end

  def _escrow!
    @escrow ||= _creative_form_helper.escrow! if _valid?
  end

  def _render_flash!
    flash.now[:error] = t(:terrible_input_data) if _invalid?
    flash[:notice] = t(:escrow_opened) if _valid?
  end

  def _existing?
    _escrow.try :valid?
  end

  def _invalid?
    !_valid?
  end

  def _valid?
    _creative_form_helper.valid?
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink params[:id]
  end
end