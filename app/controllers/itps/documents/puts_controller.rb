class Itps::Documents::PutsController < Itps::BaseController
  def update
    _update_document!
    _render_flash!
    _get_out_of_here!
  end

  def upload
    _upload_to_document!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end

  def approve
    _approve_document!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end

  def reject
    _reject_document!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end
  private
  def _update_document!
    @update_result = _document.update _update_params
  end

  def _update_params
    params.require(:itps_escrows_document).permit(:title, :description)
  end

  def _upload_to_document!
    @upload_result = _document.update _file_upload_params
  end

  def _file_upload_params
    params.require(:document).permit(:attached_file)
  end

  def _approve_document!
    @approve_result = _document.approve!
  end

  def _reject_document!
    @rejection_result = _document.reject!
  end

  def _render_flash!
    flash[:error] = t(:update_failed) if _update_failed?
    flash[:success] = t(:update_success) if _update_success?
    flash[:error] = t(:failed_to_accept_upload) if _upload_failed?
    flash[:success] = t(:upload_successful) if _upload_success?
    flash[:error] = t(:document_approval_failed) if _approve_failed?
    flash[:success] = t(:document_approved) if _approve_success?
    flash[:error] = t(:document_rejection_failed) if _rejection_failed?
    flash[:success] = t(:document_rejected) if _rejection_success?
  end

  def _update_failed?
    false == @update_result
  end

  def _update_success?
    true == @update_result
  end


  def _upload_failed?
    false == @upload_result
  end

  def _upload_success?
    true == @upload_result
  end

  def _approve_failed?
    false == @approve_result
  end

  def _approve_success?
    true == @approve_result
  end

  def _rejection_failed?
    false == @rejection_result
  end

  def _rejection_success?
    true == @rejection_result
  end

  def _get_out_of_here!
    redirect_to itps_document_path _document.permalink
  end

  def _dispatch_emails!
    Itps::DocumentMailer.approve_success_email _document if _approve_success?
    Itps::DocumentMailer.reject_success_email _document if _rejection_success?
  end

  def _document
    @document ||= Itps::Escrows::Document.find_by_permalink! params[:id]
  end
end