class Itps::Parties::BankAccountsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def new
    @bank_account = _party.bank_accounts.new
  end

  def create
    _bank_account!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _bank_account!
    @create_result = _valid? && _creative_bank_account.save
  end

  def _valid?
    _creative_bank_account.valid?
  end

  def _render_flash!
    flash[:error] = t(:failed_to_save_bank_account) if _create_unsuccessful?
    flash[:notice] = t(:bank_account_successfully_added) if _create_successful?
  end

  def _create_successful?
    true == @create_result
  end

  def _create_unsuccessful?
    false == @create_result
  end

  def _get_out_of_here!
    return redirect_to itps_account_path(_party.account) if _create_successful?
    render :new
  end

  def _creative_bank_account
    @bank_account ||= _party.bank_accounts.new _bank_account_params
  end

  def _bank_account_params
    params.require(:itps_parties_bank_account).permit(:account_number, :routing_number)
  end

  def _correct_accounts
    [_party.account]
  end

  def _party
    @party ||= Itps::Party.find_by_permalink_or_id! params[:party_id]
  end

end