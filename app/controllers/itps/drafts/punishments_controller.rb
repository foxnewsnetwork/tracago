class Itps::Drafts::PunishmentsController < Itps::Drafts::PartiesController

  private
  def _get_out_of_here!
    return redirect_to edit_itps_draft_document_path(_draft.permalink) if _update_success?
    _draft && render(:edit)
  end
  def _updative_form_helper
    _existing_form_helper.tap { |f| f.punishment_attributes = _punishment_params }
  end
  def _punishment_params
    params.require(:drafts).permit(*Itps::Drafts::FormHelper::PunishmentFields)
  end
end