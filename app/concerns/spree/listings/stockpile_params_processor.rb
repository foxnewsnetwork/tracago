class Spree::Listings::StockpileParamsProcessor
  ListingFields = [
    :available_on,
    :expires_on,
    :packing_weight_pounds,
    :days_to_refresh
  ]

  StockpileFields = [
    :pounds_on_hand,
    :cost_usd_per_pound,
    :notes
  ]

  AddressFields = [
    :address1,
    :address2,
    :city,
    :zipcode,
    :state,
    :country
  ]

  OptionValueFields = [
    :packaging,
    :process_state
  ]

  RelationalFields = [
    :origin_products,
    :material
  ]
  Fields = ListingFields + StockpileFields + AddressFields + OptionValueFields + RelationalFields

  def initialize(params)
    @params = params
  end
  
  def listing_params
    @listing_params ||= _listing_attributes.merge stockpile: _stockpile
  end

  private

  def _address
    @address ||= Spree::Address.find_roughly_or_create_by _address_param
  end

  def _address_param
    @params.permit *AddressFields
  end

  def _stockpile_params
    @stockpile_params ||= _processed_stockpile_attributes.merge address: _address, 
      material: _material
  end

  def _option_values
    OptionValueFields.map do |key|
      Spree::OptionValue.normalize! @params[key]
    end.reject(&:blank?)
  end

  def _origin_products
    _origin_products_from_presentations @params[:origin_products]
  end

  def _processed_stockpile_attributes
    _stockpile_attributes.merge option_values: _option_values, 
      origin_products: _origin_products
  end

  def _stockpile
    @stockpile ||= Spree::Stockpile.create! _stockpile_params
  end

  def _listing_attributes
    @params.permit *ListingFields
  end

  def _stockpile_attributes
    @params.permit *StockpileFields
  end

  def _material
    Spree::Material.find @params[:material]
  end

  def _origin_products_from_presentations(presentations)
    _arrayify(presentations).map { |presentation| _origin_product_from_presentation presentation }
  end

  def _arrayify(string_or_array)
    return string_or_array if string_or_array.is_a? Array
    string_or_array.split(",").map(&:strip).reject(&:blank?)
  end

  def _origin_product_from_presentation(presentation)
    Spree::OriginProduct.find_by_permalink_but_create_by_presentation!(presentation)
  end
end