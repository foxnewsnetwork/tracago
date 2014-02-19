class Itps::SecretKeys::EscrowsController < Itps::BaseController
  before_filter :_redirect_relevant_logged_in_user,
    :_filter_keyless_user
  def show
    _escrow
  end

  private
  def _filter_keyless_user
    if _incorrect_secret_key?
      redirect_to itps_login_path back: itp_escrow_path(_escrow.permalink)
      flash[:notice] = t(:your_secret_key_is_incorrect)
    end
  end

  def _incorrect_secret_key?
    _party_for_secret_key.blank?
  end

  def _party_for_secret_key
    @party ||= _escrow.party_for_secret_key params[:secret_key_id]
  end

  def _redirect_relevant_logged_in_user
    if _relevant_account?
      redirect_to itps_escrow_path itps_escrow_path _escrow.permalink
    end
  end

  def _relevant_account?
    _escrow.relevant_accounts.include? current_account
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:id]
  end
end