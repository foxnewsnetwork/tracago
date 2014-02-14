class Itps::FilesController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account,
    :_filter_undestroyable_files

  def destroy
    _destroy_file!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _filter_undestroyable_files
    if _escrow.archived? || _step.completed?
      redirect_to itps_document_path _document.permalink
      flash[:error] = t(:cannot_delete_already_archived_files)
    end
  end

  def _destroy_file!
    @destroy_result = _file.destroy
  end

  def _render_flash!
    flash[:error] = t(:could_not_delete_for_some_reason) if _destroy_failed?
    flash[:success] = t(:deleted) if _destroy_success?
  end

  def _destroy_success?
    @destroy_result.present?
  end

  def _destroy_failed?
    @destroy_result.blank?
  end

  def _get_out_of_here!
    redirect_to itps_document_path _document.permalink
  end

  def _file
    @file ||= Itps::File.find_by_permalink! params[:id]
  end

  def correct_accounts
    _escrow.relevant_accounts
  end

  def _escrow
    _document.escrow
  end

  def _step
    _document.step
  end

  def _document
    @document ||= _file.document || raise(ActiveRecord::RecordNotFound, "file##{file.id} doesn't belong to a document")
  end
end