class Itps::Drafts::ContractsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def create
    _draft_contract!
    _get_out_of_here!
  end

  private
  def _correct_accounts
    [_draft.account]
  end

  def _draft_contract!
    
  end

  def _draft
    @draft ||= Itps::Draft.find_by_permalink! params[:draft_id]
  end
end