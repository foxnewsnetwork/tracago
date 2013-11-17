class Spree::Offers::AddressesController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  def create
    _attach_address_to_offer!
    return _user_step if _offer.requires_buyer?
    return _error_step if _offer.errors.any?
    return _success_step
  end

  def new
    _offer
    _get_address_params
  end

  private

  def _error_step
    redirect_to new_offer_address_path _offer
  end

  def _success_step
    redirect_to offer_path _offer
  end

  def _attach_address_to_offer!
    _offer.address = _address!
    _offer.save!
  end

  def _address!
    @address ||= Spree::Address.find_roughly_or_create_by _address_params
  end

  def _user_step
    redirect_to new_offer_user_path _offer
  end

  def _offer
    @offer ||= Spree::Offer.find params[:offer_id]
  end

  def _address_params
    @address_params = _get_address_params.initializing_merge _post_address_params
  end

  def _get_address_params
    @address_params = params.permit(:country, :city, :state)
  end

  def _post_address_params
    @address_params = params.permit(:address => [:address1, :address2, :country, :city, :state, :zipcode])[:address]
  end
end