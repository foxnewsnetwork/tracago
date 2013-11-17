class Spree::Offers::ParamsTenderizer

  def initialize(offer)
    @offer = offer
  end

  def offer_params
    _core_params.merge _address_params
  end

  private

  def _core_params
    @offer.attributes.symbolize_keys.permit *Spree::Offers::ParamsProcessor::OfferFields
  end

  def _address_params
    _core_address_params.merge country: _address.country.id, 
      state: _address.state.id
  end

  def _address
    @offer.address
  end

  def _core_address_params
    _address.attributes.symbolize_keys.permit *Spree::Offers::ParamsProcessor::AddressFields
  end
end