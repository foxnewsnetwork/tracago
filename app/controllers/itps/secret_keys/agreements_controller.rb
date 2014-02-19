class Itps::SecretKeys::AgreementsController < Itps::BaseController
  before_filter :_filter_bad_key_account,
    :_filter_already_agreed_account
  def show
    _escrow
  end

  private

  def _secret_key_agree_path
    itps_secret_key_agreement_path(params[:secret_key_id], _escrow.permalink)
  end

  def _secret_key_escrow_path
    itps_secret_key_escrow_path(params[:secret_key_id], _escrow.permalink)
  end

  def _dispatch_emails!

  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:id]
  end

  def _secret_key_party
    @party ||= _escrow.party_for_secret_key params[:secret_key_id]
  end
  
  def _filter_bad_key_account
    if _secret_key_party.blank?
      flash[:notice] = t(:your_secret_key_does_not_match_the_escrow)
      redirect_to itps_escrow_path _escrow.permalink
    end
  end

  def _filter_already_agreed_account
    if _escrow.already_agreed_parties.include? _secret_key_party
      flash[:notice] = t(:you_have_already_agreed_to_the_contract)
      redirect_to _secret_key_escrow_path
    end
  end

end