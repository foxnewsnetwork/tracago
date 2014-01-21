class Itps::BankAccountsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  def edit
    _party
    _bank_account
  end

  def update
    _update_bank_account!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _correct_accounts
    [_party.account]
  end

  def _update_bank_account!
    @update_result = _bank_account.update_attributes _bank_account_params
  end

  def _bank_account_params
    params.require(:itps_parties_bank_account).permit(:account_number, :routing_number)
  end

  def _update_successful?
    true == @update_result
  end

  def _update_failed?
    false == @update_result
  end

  def _render_flash!
    flash[:error] = t(:failed_to_update) if _update_failed?
    flash[:notice] = t(:update_successful) if _update_successful?
  end

  def _get_out_of_here!
    return redirect_to itps_account_path _party.account if _update_successful?
    render :edit
  end

  def _party
    @party ||= _bank_account.party
  end

  def _bank_account
    @bank_account ||= Itps::Parties::BankAccount.find_by_bullshit_id! params[:id]
  end
end