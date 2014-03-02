class Itps::Drafts::Punishments::DeductionsController < Itps::Drafts::PunishmentsController
  def create
    _punishment!
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
    return flash[:success] = t(:punishment_added) if _create_success?
    flash[:error] = t(:invalid_punishment_entry)
  end

  def _get_out_of_here_json!
    return render json: _punishment if _create_success?
    render json: _punishment.errors.as_json, status: 400
  end

  def _create_success?
    true == @create_result
  end

  def _get_out_of_here_html!
    return redirect_to edit_itps_draft_punishment_path _draft.permalink if _create_success?
    _existing_form_helper && render(:edit)
  end

  def _punishment
    @item ||= _draft.punishments.new _punishment_params
  end

  def _punishment!
    @create_result = _punishment.valid? && _punishment.save
  end

  def _punishment_params
    params.require(:itps_drafts_punishment).permit(:minimum_quantity,
      :maximum_quantity,
      :quantity_unit,
      :price_deduction,
      :price_unit,
      :comparison_type,
      :memo)
  end

  def _correct_accounts
    [_draft.account]
  end

  def _draft
    @draft ||= Itps::Draft.find_by_permalink! params[:punishment_id]
  end
end