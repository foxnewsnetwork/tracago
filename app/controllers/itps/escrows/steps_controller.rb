class Itps::Escrows::StepsController < Itps::BaseController
  def new
    _form_helper
  end

  def create
    _step!
    _render_flash!
    _redirect_somewhere!
  end

  private
  def _step!
    @step ||= _creative_form_helper.step!
  end

  def _creative_form_helper
    _form_helper.tap { |f| f.attributes = _raw_step_params }
  end

  def _raw_step_params
    params.require(:steps).permit *Itps::Escrows::Steps::StepFormHelper::Fields
  end

  def _step
    @step ||= Itps::Escrows::Step.find_by_permalink params[:id]
  end

  def _render_flash!
    flash.now[:error] = _errors if _invalid?
    flash[:notice] = t(:step_added) if _valid?
  end

  def _valid?
    _form_helper.valid?
  end

  def _invalid?
    !_valid?
  end

  def _created?
    _step.persisted?
  end

  def _redirect_somewhere!
    return redirect_to itps_step_path(_step.permalink) if _created?
    return render :new
  end

  def _form_helper
    @form_helper ||= Itps::Escrows::Steps::StepFormHelper.new _escrow
  end

  def _escrow
    @escrow = Itps::Escrow.find_by_permalink! params[:escrow_id]
  end
end