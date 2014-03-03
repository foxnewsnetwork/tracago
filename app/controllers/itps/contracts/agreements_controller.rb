class Itps::Contracts::AgreementsController < Itps::ContractsController
  before_filter :_redirect_already_agreed_contract

  def new
    _view_helper
  end

  def create

  end

  private

  def _redirect_already_agreed_contract
    if _contract.already_agreed? current_account
      redirect_to itps_escrow_path _contract.escrow.permalink
      flash[:notice] = t(:you_have_already_agreed_to_this_contract)
    end
  end

  def _contract
    @contract ||= Itps::Contract.find_by_permalink_or_bullshit_id! params[:contract_id]
  end
end