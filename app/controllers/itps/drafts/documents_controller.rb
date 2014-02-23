class Itps::Drafts::DocumentsController < Itps::Drafts::PartiesController

  private
  def _get_out_of_here!
    return redirect_to edit_itps_draft_review_path(_draft.permalink) if _update_success?
    _draft && render(:edit)
  end
  def _updative_form_helper
    _existing_form_helper.tap { |f| f.document_attributes = _document_params }
  end
  def _document_params
    params.require(:drafts).permit(*Itps::Drafts::FormHelper::DocumentFields)
  end
end