class Itps::Drafts::Commodities::ItemsController < Itps::Drafts::CommoditiesController

  def create
    _item!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _get_out_of_here!
    respond_to do |format|
      format.html { _get_out_of_here_html! }
      format.json { _get_out_of_here_json! }
    end
  end

  def _render_flash!
    return flash[:success] = t(:item_added) if _create_success?
    flash[:error] = t(:invalid_item_entry)
  end

  def _get_out_of_here_json!
    return render json: _item if _create_success?
    render json: _item.errors.as_json, status: 400
  end

  def _create_success?
    true == @create_result
  end

  def _get_out_of_here_html!
    return redirect_to edit_itps_draft_commodity_path _draft.permalink if _create_success?
    _existing_form_helper && render(:edit)
  end

  def _item
    @item ||= _draft.items.new _item_params
  end

  def _item!
    @create_result = _item.valid? && _item.save
  end

  def _item_params
    params.require(:itps_drafts_item).permit(:name, :unit, :quantity, :price)
  end

  def _correct_accounts
    [_draft.account]
  end

  def _draft
    @draft ||= Itps::Draft.find_by_permalink! params[:commodity_id]
  end
end