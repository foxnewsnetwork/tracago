class Itps::Drafts::ItemsController < Itps::Drafts::Commodities::ItemsController

  def destroy
    flash[:error] = t(:cannot_delete) unless _item.destroy
    redirect_to edit_itps_draft_commodity_path _draft.permalink
  end
  private
  def _item
    @item ||= Itps::Drafts::Item.find params[:id]
  end
  def _draft
    _item.draft
  end
end