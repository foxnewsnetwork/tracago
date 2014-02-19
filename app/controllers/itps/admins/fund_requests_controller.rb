class Itps::Admins::FundRequestsController < Itps::AdminBaseController
  def index
    _fund_requests
  end

  def edit
    _fund_request
  end

  def update
    _update_fund_request!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _update_fund_request!
    @update_result = _fund_request.fulfill! *_files_array
  end
  def _files_array
    _files_params[:files].to_a
  end
  def _files_params
    params.require(:itps_accounts_fund_request).permit(:files)
  end
  def _render_flash!
    flash[:success] = t(:successfully_fulfilled) if _update_success?
    flash[:error] = t(:failed) if _update_failed?
  end
  def _update_success?
    @update_result == true
  end
  def _update_failed?
    false == @update_result
  end
  def _get_out_of_here!
    return redirect_to itps_admin_fund_requests_path if _update_success?
    render :edit
  end
  def _fund_request
    @fund_request ||= Itps::Accounts::FundRequest.find params[:id]
  end

  def _fund_requests
    return _fulfilled_fund_requests if _fulfilled?
    _unfulfilled_fund_requests
  end

  def _unfulfilled_fund_requests
    @fund_requests ||= Itps::Accounts::FundRequest.unfulfilled.page(params[:page]).per(params[:per_page])
  end

  def _fulfilled_fund_requests
    @fund_requests ||+ Itps::Accounts::FundRequest.fulfilled.page(params[:page]).per(params[:per_page])
  end

  def _fulfilled?
    'fulfilled' == params[:show].to_s
  end
end