class Itps::PartiesController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account,
    only: [:edit, :update]
  def show
    _party
  end

  def edit
    _party
  end

  def update
    _update_party!
    _render_flash!
    _get_out_of_here!
  end
  private
  def _correct_accounts
    [_party.account]
  end
  
  def _party
    @party ||= Itps::Party.find_by_permalink_or_id! params[:id]
  end

  def _update_party!
    @update_result = _party.update _part_params
  end

  def _render_flash!
    flash[:error] = t(:failed_to_update) if _update_failed?
    flash[:success] = t(:update_success) if _update_successful?
  end

  def _update_failed?
    false == @update_result
  end

  def _update_successful?
    true == @update_result
  end


  def _get_out_of_here!
    return redirect_to itps_account_path _party.account if _update_successful?
    return render :edit if _update_failed?
  end

  def _part_params
    params.require(:itps_party).permit(:company_name)
  end

end