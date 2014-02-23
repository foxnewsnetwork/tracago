class Itps::Buys::InternationalsController < Itps::BaseController
  before_filter :filter_anonymous_account, only: [:new, :create]
  before_filter :filter_anonymous_account,
    :filter_wrong_account,
    only: [:edit, :update]

  def edit
    _existing_form_helper
  end

  def new
    _form_helper
  end

  def create
    _draft!
    _get_out_of_here!
  end

  def update
    _update_draft!
    _get_out_of_here!
  end

  private
  def _correct_accounts
    [_draft.account]
  end
  def _party_params
    params.require(:drafts).permit(*Itps::Drafts::FormHelper::PartyFields)
  end
  def _get_out_of_here!
    return redirect_to edit_itps_draft_party_path @draft.permalink if _create_success?
    return render :new if _create_failed?
    return redirect_to edit_itps_draft_party_path @draft.permalink if _update_success?
    return render :edit if _update_failed?
    throw 'UnknownCommand'
  end
  def _update_success?
    _form_helper.update_success?
  end
  def _update_failed?
    _form_helper.update_failed?
  end
  def _create_success?
    @draft.present? && @draft.persisted?
  end
  def _create_failed?
    !@draft.try(:persisted?)
  end
  def _draft!
    @draft = _creative_form_helper.draft!
  end
  def _update_draft!
    @draft = _updative_form_helper.draft!
  end
  def _existing_form_helper
    @form_helper ||= Itps::Drafts::FormHelper.new.tap { |f| f.draft = _draft }
  end
  def _creative_form_helper
    _form_helper.tap { |f| f.party_attributes_as_buyer = _party_params }
  end
  def _updative_form_helper
    _existing_form_helper.tap { |f| f.party_attributes_as_buyer = _party_params }
  end
  def _form_helper
    @form_helper ||= Itps::Drafts::FormHelper.new.tap { |f| f.account = current_account }
  end
  def _draft
    @draft ||= Itps::Draft.find_by_permalink! params[:id]
  end
end