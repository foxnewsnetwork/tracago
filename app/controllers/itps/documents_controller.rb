class Itps::DocumentsController < Itps::BaseController
  def show
    _document
  end

  def edit
    _document
  end

  def destroy
    _destroy_document!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _document
    @document ||= Itps::Escrows::Document.find_by_permalink! params[:id]
  end

  def _destroy_document!
    _document.destroy
  end

  def _destroy_successful?
    !_document.persisted?
  end

  def _destroy_failed?
    _document.persisted?
  end

  def _render_flash!
    flash[:error] = t(:failed_to_destroy) if _destroy_failed?
    flash[:notice] = t(:document_destroyed) if _destroy_successful?
  end

  def _get_out_of_here!
    redirect_to itps_document_path _document.permalink if _destroy_failed?
    redirect_to itps_step_path _document.step.permalink if _destroy_successful?
  end
end