class Itps::Steps::DocumentsController < Itps::BaseController
  def new
    _document
  end

  def create
    _document!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _document!
    @document ||= _step.documents.new _document_params
  end

  def _valid?
    @result ||= _document.valid? && _document.save
  end

  def _render_flash!
    flash.now[:error] = _document.errors.full_message.join(", ") unless _valid?
    flash[:notice] = t(:successfully_created) if _valid?
  end

  def _get_out_of_here!
    return redirect_to itps_step_path _document.step.permalink if _valid?
    return render :new unless _valid?
  end

  def _document_params
    params.require(:itps_escrows_document).permit(:title, :description)
  end

  def _document
    @document ||= _step.documents.new
  end

  def _step
    Itps::Escrows::Step.find_by_permalink! params[:step_id]
  end
end