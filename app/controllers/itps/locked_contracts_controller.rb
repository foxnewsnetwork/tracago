class Itps::LockedContractsController < Itps::ContractsController
  before_filter :_redirect_unlocked_contracts

  private
  def _redirect_unlocked_contracts
    unless _contract.locked?
      redirect_to itps_contract_path _contract.bullshit_id
    end
  end
end