class Itps::Escrows::AgreementsController < Itps::BaseController
  def new
    _escrow
  end

  def create
    _agreement!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end

  private
  def _dispatch_emails!
    _email_helper.dispatch! if @result
  end

  def _email_helper
    @email_helper ||= Itps::Escrows::AgreementEmailHelper.new
  end

  def _render_flash!
    return flash[:notice] = t(:escrow_opened) if @result
    flash.now[:error] = t(:you_need_to_agree_to_the_user_agreement)
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if @result
    return render :agreement
  end

  def _agreement!
    @result ||= _escrow.other_party_agree! if _agreement_params[:agree].present?
  end

  def _agreement_params
    params.require(:escrows).permit(:agree)
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_mysteriously_encryped_key! _mysteriously_encrypted_params
  end

  def _mysteriously_encrypted_params
    {
      mysterious_key: params[:escrow_id],
      work: params[:work].present?
    }
  end
end