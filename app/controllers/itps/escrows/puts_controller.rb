class Itps::Escrows::PutsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def edit
    _escrow
    render 'itps/escrows/edit'
  end

  def update
    _update_escrow!
    _render_flash!
    _get_out_of_here!
  end
  private
  def _correct_accounts
    _escrow.relevant_accounts
  end

  def _update_escrow!
    @update_result = _escrow.update _escrow_params if _escrow.edit_mode?
  end
  def _render_flash!
    flash[:error] = t(:cannot_edit_locked_escrow) if _locked_escrow?
    flash[:error] = t(:unable_to_update_for_some_reason) if _update_failed?
    flash[:success] = t(:update_successful) if _update_success?
  end
  def _locked_escrow?
    @update_result.nil?
  end
  def _update_failed?
    false == @update_result
  end
  def _update_success?
    true == @update_result
  end
  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if _locked_escrow? || _update_success?
    render :edit
  end
  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:id]
  end
  def _escrow_params
    params.require(:itps_escrow).permit(:dollar_amount)
  end
end