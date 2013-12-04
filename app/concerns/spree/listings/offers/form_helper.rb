class Spree::Listings::Offers::FormHelper < Spree::FormHelperBase
  Fields = [
    :shipping_terms,
    :country,
    :state,
    :city,
    :address1,
    :usd_per_pound,
    :loads,
    :minimum_pounds_per_load
  ]
  attr_hash_accessor *Fields
  validates_with Spree::Listings::Offers::ShippingTermsValidator
  validates_with Spree::Listings::Offers::CountryValidator
  validates :usd_per_pound, :loads,
    presence: true,
    numericality: { greater_than: 0 }
  validates :shipping_terms,
    presence: true,
    inclusion: { in: Spree::Offer::Terms }

  attr_accessor :attributes
  def initialize(listing, attributes={})
    super attributes
    @listing = listing
  end

  def offer_params
    _processed_params
  end

  def to_partial_path
    Spree.r.listing_offers_path(@listing)
  end

  private

  def _processed_params
    {
      address: _processed_address,
      usd_per_pound: usd_per_pound,
      loads: loads,
      minimum_pounds_per_load: minimum_pounds_per_load,
      shipping_terms: shipping_terms
    }
  end

  def _processed_address
    @address ||= _processed_city.addresses.find_or_create_by address1: address1
  end

  def _processed_city
    @city ||= _processed_state.cities.find_or_create_by romanized_name: city
  end

  def _processed_state
    @state ||= _processed_country.states.find_or_create_by romanized_name: state
  end

  def _processed_country
    @country ||= Spree::Country.find_by_romanized_name! country
  end
end