class Itps::Escrows::DeleteController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  def destroy
    _destroy_escrow!
    _render_flash!
    _get_out_of_here!  
  end

  private
  def _correct_accounts
    [_escrow.draft_party.account]
  end

  def _destroy_escrow!
    @destroy_result = _escrow.attempt_destroy!
  end

  def _render_flash!
    flash[:success] = t(:contract_successful_destroyed) if _destroy_success?
    flash[:error] = t(:contract_cannot_be_destroyed) if _destroy_failed?
  end

  def _destroy_success?
    true == @destroy_result
  end

  def _destroy_failed?
    false == @destroy_result
  end

  def _get_out_of_here!  
    return redirect_to itps_account_path current_account if _destroy_success?
    redirect_to itps_escrow_path _escrow.permalink if _destroy_failed?
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:id]
  end
end