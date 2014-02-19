class Itps::SecretKeys::Escrows::SessionsController < Itps::BaseController
  before_filter :_filter_logged_in_account,
    :_filter_badkey_account,
    :_filter_party_based_on_account
  
  def new; end

  private
  def _filter_logged_in_account
    if user_signed_in?
      redirect_to new_itps_escrow_agreement_path _escrow.permalink
      flash[:notice] = t(:you_are_already_logged_in)
    end
  end

  def _filter_badkey_account
    if _party.blank?
      redirect_to itps_escrow_path _escrow.permalink
      flash[:error] = t(:your_secret_key_does_not_match_the_contract)
    end
  end

  def _filter_party_based_on_account
    if _party.account.blank?
      redirect_to new_itps_secret_key_escrow_registration_path params[:secret_key_id], _escrow.permalink
      flash[:notice] = t(:this_party_does_not_have_a_matching_account_yet)
    end
  end

  def _party
    @party ||= _escrow.party_for_secret_key params[:secret_key_id]
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:escrow_id]
  end
end