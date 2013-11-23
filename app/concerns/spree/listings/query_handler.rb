class Spree::Listings::QueryHandler
  include ActiveModel::Validations
  Fields = [:page, :per_page, :cat, :key]
  EmbeddedFields = [:state, :country, :city, :shop]
  attr_hash_accessor *(Fields + EmbeddedFields)

  class << self
    def model_name
      ActiveModel::Name.new self, nil, "key"
    end
  end

  def to_key
    nil
  end

  def persisted?
    false
  end

  def to_partial_path
    Spree.r.listings_path
  end

  def to_param
    nil
  end

  def initialize(attributes={})
    @attributes = attributes
    @attributes.merge! @attributes.delete(:key).permit(*EmbeddedFields) if key.is_a? Hash
  end

  def shops
    return Spree::Shop.with_most_listings 9 if shop.blank?
    return Spree::Shop.poor_man_search(shop)
  end

  def listings
    _listings.page(page).per(per_page)
  end

  def page
    @attributes[:page] || 1
  end

  def per_page
    @attributes[:per_page] || 10
  end

  def show_state?
    country.present?
  end

  def show_city?
    show_state? && state.present?
  end

  def country_options_arrays
    Spree::Country.select_options_arrays
  end

  def state_options_arrays
    _country.states.map(&:select_options_array)
  end

  def city_options_arrays
    _state.cities.map(&:select_options_array)
  end

  private

  def _listings
    return _material_listings if _material?
    return _location_listings if _location?
    return _company_listings if _company?
    return _vanilla_listings
  end

  def _vanilla_listings
    Spree::Listing.order("created_at desc")
  end

  def _material_listings
    _material.try(:listings)
  end

  def _material
    Spree::Material.normalize key
  end

  def _location_listings
    _most_specific_thing_with_listings.listings
  end

  def _most_specific_thing_with_listings
    _city || _state || _country
  end

  def _state
    Spree::State.normalize state if state.present?
  end

  def _country
    Spree::Country.normalize country if country.present?
  end

  def _city
    Spree::City.normalize city if city.present?
  end

  def _company_listings
    _shop.try(:listings)
  end

  def _shop
    Spree::Shop.normalize key
  end

  def _material?
    "material" == cat && key.present?
  end

  def _location?
    "location" == cat && country.present?
  end

  def _company?
    "company" == cat && key.present?
  end

end