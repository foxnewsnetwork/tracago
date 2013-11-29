class Spree::Listings::Offers::FormHelper
  include ActiveModel::Validations
  class << self
    def model_name
      ActiveModel::Name.new self, nil, "offer"
    end
  end
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
  def initialize(listing, attributes={})
    @listing = listing
    @attributes = attributes
  end

  def persisted?
    false
  end

  def to_partial_path
    Spree.r.listing_offers_path(@listing)
  end

  def to_param
    nil
  end

  def to_key
    nil
  end
end