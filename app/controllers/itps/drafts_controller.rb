class Itps::DraftsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def show
    _international_redirect if _draft.international?
    _domestic_redirect if _draft.domestic?
  end
  private
  def _international_redirect
    redirect_to edit_itps_draft_review_path _draft.permalink
  end

  def _domestic_redirect
  
  end

  def _correct_accounts
    [_draft.account]
  end

  def _draft
    @draft ||= Itps::Draft.find_by_permalink! params[:id]
  end
end