class Spree::Listings::FormHelper
  include ActiveModel::Validations
  class << self
    def model_name
      ActiveModel::Name.new self, nil, "listing"
    end
  end
  attr_hash_accessor *Spree::Listings::StockpileParamsProcessor::Fields
  validates_presence_of :material, :origin_products, :address1, :city, :country
  validates :pounds_on_hand, numericality: { greater_than: 0, only_integer: true }, presence: true
  validates_with Spree::Listings::MaterialValidator
  validates_with Spree::Listings::GeographicValidator

  def flash_message
    _handler.flash_message
  end

  def initialize(attributes={})
    @attributes = attributes
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

  def to_key
    nil
  end
  
  def listing_params
    Spree::Listings::StockpileParamsProcessor.new(@attributes).listing_params
  end


  private

  def _handler
    @handler ||= Spree::Listings::ExceptionHandler.new(valid? || errors)
  end

end