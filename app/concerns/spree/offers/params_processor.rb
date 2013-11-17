class Spree::Offers::ParamsProcessor

  OfferFields = [
    :expires_at,
    :usd_per_pound,
    :shipping_terms,
    :minimum_pounds_per_load,
    :transport_method
  ]
  AddressFields = [
    :address1,
    :address2,
    :city,
    :zipcode,
    :state,
    :country
  ]
  AllFields = OfferFields + AddressFields
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
  end

  def offer_params
    return _core_offer_params if _missing_address_fields?
    _core_offer_params.merge address: _address
  end

  private

  def _missing_address_fields?
    !_has_address_fields?
  end

  def _has_address_fields?
    @missing_address_fields ||= AddressFields.reject do |key|
      :address2 == key
    end.inject(true) do |has_key, field|
      has_key && @attributes[field].present?
    end
  end

  def _core_offer_params
    attributes.permit *OfferFields
  end

  def _address
    @address ||= Spree::Address.find_roughly_or_create_by _address_params
  end

  def _address_params
    attributes.permit *AddressFields
  end


end