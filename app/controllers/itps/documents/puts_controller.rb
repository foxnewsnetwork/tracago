class Itps::Documents::PutsController < Itps::BaseController
  before_filter :filter_anonymous_accounts
  before_filter :_filter_edit_mode_escrows,
    only: [:approve, :reject]
  before_filter :filter_wrong_account
  before_filter :_filter_active_mode_escrows,
    only: [:update]
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
  def _correct_accounts
    _escrow.relevant_accounts
  end

  def _escrow
    _document.escrow
  end

  def _filter_active_mode_escrows
    if _document.escrow.opened?
      redirect_to _itps_document_path _document.permalink
      flash[:error] = t(:document_specs_cannot_be_altered_after_a_contract_has_been_locked)
    end
  end

  def _filter_edit_mode_escrows
    if _document.edit_mode?
      redirect_to _itps_document_path _document.permalink
      flash[:error] = t(:document_rejection_and_approval_disabled_during_edit_mode)
    end
  end

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
     _approve_success_email.deliver! if _approve_success?
     _reject_success_email.deliver! if _rejection_success?
  end

  def _approve_success_email
    Itps::DocumentMailer.approve_success_email(_document)
  end
  def _reject_success_email
    Itps::DocumentMailer.reject_success_email(_document)
  end

  def _document
    @document ||= Itps::Escrows::Document.find_by_permalink! params[:id]
  end
end