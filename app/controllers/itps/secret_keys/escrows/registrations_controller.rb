class Itps::SecretKeys::Escrows::RegistrationsController < Itps::SecretKeys::Escrows::SessionsController

  private
  def _filter_party_based_on_account
    if _party.account.present?
      redirect_to new_itps_secret_key_escrow_session_path params[:secret_key_id], _escrow.permalink
      flash[:notice] = t(:this_email_has_already_been_used)
    end
  end
end