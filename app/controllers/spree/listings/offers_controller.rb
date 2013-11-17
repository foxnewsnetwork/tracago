class Spree::Listings::OffersController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper 'spree/taxons'

  def index
    _listing
  end

  def create
    return _address_step  if _offer.requires_destination?
    return _user_step     if _offer.requires_buyer?
    return _error_step    if _offer.errors?
  end

  private

  def _address_step
    _some_step { |*o| new_offer_address_path *o }
  end

  def _user_step
    _some_step { |*o| new_offer_user_path *o }
  end

  def _error_step
    _some_step { |*o| offer_path *o }
  end

  def _some_step(&block)
    redirect_to yield(_offer, _address_params)
  end

  def _offer
    @offer ||= _listing.offers.create _offer_params
  end

  def _listing
    @listing ||= Spree::Listing.find params[:listing_id]
  end

  def _offer_params
    vanilla_offer = params.require(:offer).permit(:containers, :shipping_terms, :usd_per_pound)
    vanilla_offer.initializing_merge user: current_user
    vanilla_offer.alter_key_from(:containers).to(:loads)
  end

  def _address_params
    params.require(:offer).permit(:country, :state, :city)
  end

end