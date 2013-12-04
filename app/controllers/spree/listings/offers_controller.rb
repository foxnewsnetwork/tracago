class Spree::Listings::OffersController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper 'spree/taxons'

  def index
    _listing
  end

  def create
    return _error_step          unless _valid?
    return _user_step           if _offer.requires_buyer?
    return _confirmation_step
  end

  def new
    _form_helper
  end

  private

  def _valid?
    _create_form_helper.valid? && _offer.valid?
  end

  def _form_helper
    @form_helper ||= Spree::Listings::Offers::FormHelper.new _listing
  end

  def _create_form_helper
    _form_helper.tap { |f| f.attributes = _offer_params }
  end

  def _confirmation_step
    redirect_to confirmation_offer_path _offer
  end

  def _user_step
    flash[:notice] = t(:signin_to_finish_making_offer)
    redirect_to login_path back: confirmation_offer_path(_offer)
  end

  def _error_step
    flash.now[:error] = _form_helper.errors.full_messages
    render :new
  end

  def _some_step(&block)
    redirect_to yield _offer
  end

  def _offer
    @offer ||= _listing.offers.create! _processed_offer_params
  end

  def _processed_offer_params
    _create_form_helper.offer_params
  end

  def _listing
    @listing ||= Spree::Listing.find params[:listing_id]
  end

  def _offer_params
    params.require(:offers).permit *Spree::Listings::Offers::FormHelper::Fields
  end

end