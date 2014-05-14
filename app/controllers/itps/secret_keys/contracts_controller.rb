class Itps::SecretKeys::ContractsController < Itps::BaseController
  before_filter :_redirect_already_agreed_contracts,
    :_filter_mismatching_keys

  # itps/secret_keys/205ad2ecd16f75eaffb07f789a4c9901/contracts/165461-cc
  def show
    _contract
  end

  def create
    _create_agreement!
    _render_flash
    _get_out
    _send_emails
  end

  private
  def _redirect_already_agreed_contracts
    if _already_agreed?
      redirect_to itps_contract_path(_contract.bullshit_id)
      flash[:notice] = t(:you_have_already_agreed)
    end
  end
  def _filter_mismatching_keys
    if _mismatch_key?
      flash[:error] = "given:#{_given_secret_key} -- expected:#{_expected_secret_key}"
      redirect_to itps_path
    end
  end
  def _already_agreed?
    _escrow.already_agreed? _party
  end
  def _party
    current_account.try(:party) || _escrow.party_for_secret_key(_given_secret_key)
  end
  def _escrow
    _contract.escrow
  end
  def _mismatch_key?
    _given_secret_key != _expected_secret_key
  end
  def _given_secret_key
    params[:secret_key_id].to_s
  end
  def _expected_secret_key
    _contract.secret_key.to_s
  end
  def _contract
    @contract ||= Itps::Contract.find_by_permalink_or_bullshit_id! params[:id]
  end
end