class Itps::Escrows::EscrowsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def new
    _form_helper
  end

  def create
    _clone_escrow!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _correct_accounts
    _escrow.relevant_accounts
  end

  def _clone_escrow!
    @escrow = _form_helper.escrow! if _create_success?
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _escrow_params
      f.escrow = _escrow
      f.account = current_account
    end
  end

  def _form_helper
    @form_helper ||= Itps::Escrows::Escrows::FormHelper.new
  end

  def _render_flash!
    flash[:success] = t(:contract_successfully_cloned) if _create_success?
    flash[:error] = t(:unable_to_clone_contract) if _create_failed?
  end

  def _create_success?
    _creative_form_helper.create_success?
  end

  def _create_failed?
    _creative_form_helper.create_failed?
  end

  def _get_out_of_here!
    return redirect_to itps_escrow_path(_escrow.permalink) if _create_success?
    render :new
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:escrow_id]
  end

  def _escrow_params
    params.require(:escrows).permit *Itps::Escrows::Escrows::FormHelper::Fields
  end
end