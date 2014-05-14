class Itps::Contracts::AgreementsController < Itps::ContractsController
  before_filter :_redirect_already_agreed_contract

  def new
    _view_helper
  end

  def create
    _agreement!
    _render_flash!
    _get_out_of_here!
    _dispatch_emails!
  end

  private
  def _agreement!
    @agreement_result = _interactor.agree!
  end
  def _interactor
    @interactor ||= Itps::Contracts::Agreements::Interactor.new(_contract).tap do |i|
      i.attributes = _contract_agreement_params
    end
  end
  def _contract_agreement_params
    # TODO: make it so that contract text is generated entirely internally to prevent terrible terrible xss and stuff
    params.require(:agreements).permit(*Itps::Contracts::Agreements::Interactor::Fields)
  end
  def _render_flash!
    flash[:success] = t(:you_have_successfully_agreed) if @agreement_result.success?
    flash[:error] = t(:could_not_agree) if @agreement_result.failed?
  end
  def _get_out_of_here!
    return redirect_to itps_escrow_path _escrow.permalink if @agreement_result.success?
    render :new
  end
  def _escrow
    _interactor.escrow
  end
  def _dispatch_emails!
    _emailer.inform_other_party! if @agreement_result.success?
  end
  def _emailer
    @emailer ||= Itps::Contracts::Agreements::Emailer.new _contract
  end
  def _redirect_already_agreed_contract
    if _contract.already_agreed? current_account
      redirect_to itps_escrow_path _contract.escrow.permalink
      flash[:notice] = t(:you_have_already_agreed_to_this_contract)
    end
  end

  def _contract
    @contract ||= Itps::Contract.find_by_permalink_or_bullshit_id! params[:contract_id]
  end
end