class Itps::Drafts::DeductionsController < Itps::Drafts::Punishments::DeductionsController

  def destroy
    flash[:error] = t(:cannot_delete) unless _punishment.destroy
    redirect_to edit_itps_draft_punishment_path _draft.permalink
  end

  def update
    flash[:error] = t(:cannot_update) unless _punishment.update _punishment_params
    redirect_to edit_itps_draft_punishment_path _draft.permalink
  end
  private
  def _punishment
    @punishment ||= Itps::Drafts::Punishment.find params[:id]
  end
  def _draft
    _punishment.draft
  end
end