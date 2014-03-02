class Itps::ContractsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account  
  def show
    _view_helper
  end

  private
  def _correct_accounts
    [_contract.account]
  end
  def _view_helper
    @view_helper ||= Itps::Contracts::ViewHelper.new _contract
  end
  def _contract
    @contract ||= Itps::Contract.find_by_permalink_or_bullshit_id! params[:id]
  end
end