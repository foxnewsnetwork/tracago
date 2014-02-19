class Itps::SecretKeys::Escrows::AgreementsController < Itps::BaseController
  before_filter :_filter_bad_key_accounts,
    :_filter_relevant_account,
    :_filter_irrelevant_account

  def new
    _escrow
  end

  private
  def _filter_bad_key_accounts
    if _secret_key_party.blank?
      redirect_to itps_escrow_path _escrow.permalink
      flash[:notice] = t(:that_key_does_not_match_the_given_contract)
    end
  end

  def _filter_relevant_account
    if _escrow.relevant_accounts.include? _secret_key_account
      redirect_to new_itps_escrow_agreement_path _escrow.permalink
    end
  end

  def _secret_key_party
    @party ||= _escrow.party_for_secret_key params[:secret_key_id]
  end

  def _secret_key_account
    _secret_key_party.try :account
  end

  def _filter_irrelevant_account
    if current_account.present? && _mismatch_account?
      redirect_to itps_escrow_path _escrow.permalink
      flash[:notice] = t(:that_key_does_not_belong_to_you)
    end
  end

  def _mismatch_account?
    current_account != _secret_key_account
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:escrow_id]
  end
end