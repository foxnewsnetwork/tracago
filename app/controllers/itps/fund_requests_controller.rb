class Itps::FundRequestsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def edit
    _fund_request
  end

  def update
    _update_fund_request!
    _render_flash!
    _get_out_of_here!
  end

  def destroy
    _destroy_fund_request!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _destroy_fund_request!
    @destroy_result = _fund_request.destroy
  end
  def _update_fund_request!
    @update_result = _fund_request.update _fund_request_params
  end
  def _update_success?
    true == @update_result
  end
  def _update_failed?
    false == @update_result
  end
  def _destroy_success?
    @destroy_result.is_a? Itps::Accounts::FundRequest
  end
  def _destroy_failed?
    false == @destroy_result
  end
  def _render_flash!
    flash[:success] = t(:update_successful) if _update_success?
    flash[:error] = t(:update_failed) if _update_failed?
    flash[:success] = t(:destroy_successful) if _destroy_success?
    flash[:error] = t(:destroy_failed) if _destroy_failed?
  end
  def _get_out_of_here!
    return redirect_to itps_account_path _fund_request.accouunt if _update_success?
    return render :edit if _update_failed?
    return redirect_to edit_itps_fund_request_path _fund_request if _destroy_failed?
    redirect_to itps_account_path current_account.permalink
  end
  def _correct_accounts
    [_fund_request.account]
  end
  def _fund_request_params
    params.require(:itps_accounts_fund_request).permit(:dollar_amount, :memo)
  end
  def _fund_request
    @fund_request ||= Itps::Accounts::FundRequest.find params[:id]
  end
end