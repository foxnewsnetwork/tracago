class Itps::Accounts::FundRequestsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account,
    :_filter_already_requested_account

  def new
    _fund_request
  end

  def create
    _fund_request!
    _render_flash!
    _get_out_of_here!
  end
  private
  def _filter_already_requested_account
    if _account.active_fund_request.present?
      redirect_to edit_itps_fund_request_path _fund_request
      flash[:notice] = t(:you_already_have_an_active_fund_request)
    end
  end
  def _correct_accounts
    [_account]
  end
  def _fund_request
    @fund_request ||= _account.fund_requests.new
  end
  def _creative_fund_request
    @fund_request ||= _account.fund_requests.new _fund_request_params
  end
  def _fund_request!
    @create_result = _creative_fund_request.valid? && _creative_fund_request.save
  end
  def _fund_request_params
    params.require(:itps_accounts_fund_request).permit(:dollar_amount, :memo)
  end
  def _render_flash!
    flash[:success] = t(:your_request_is_being_processed) if _create_success?
    flash[:error] = t(:something_went_wrong_with_processing_your_request) if _create_failed?
  end
  def _create_success?
    true == @create_result
  end
  def _create_failed?
    false == @create_result
  end
  def _get_out_of_here!
    return redirect_to itps_account_path(current_account.permalink) if _create_success?
    render :new
  end
  def _account
    @account ||= Itps::Account.find_by_id_or_permalink! params[:account_id]
  end

end