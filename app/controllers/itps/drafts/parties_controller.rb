class Itps::Drafts::PartiesController < Itps::Buys::InternationalsController

  def edit
    _existing_form_helper
  end

  def update
    _update_draft!
    _get_out_of_here!
  end

  private
  def _get_out_of_here!
    return redirect_to edit_itps_draft_commodity_path(_draft.permalink) if _update_success?
    _draft && render(:edit)
  end
  def _updative_form_helper
    _existing_form_helper.tap { |f| f.sellers_attributes_as_buyer = _seller_params }
  end
  def _seller_params
    params.require(:drafts).permit(*Itps::Drafts::FormHelper::SellerFields)
  end
  
end