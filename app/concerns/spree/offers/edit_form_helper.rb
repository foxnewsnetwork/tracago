class Spree::Offers::EditFormHelper
  include ActiveModel::Validations

  validates_with Spree::Countries::Validator
  validates_with Spree::States::Validator
  validates_with Spree::Addresses::Validator
  validates :address1, :city, :country, presence: true
  validates :transport_method, 
    presence: true,
    inclusion: { in: Spree::Offer::TransportMethods }
  validates :usd_per_pound,
    presence: true,
    numericality: { greater_than: 0 }
  validates :shipping_terms,
    presence: true,
    inclusion: { in: Spree::Offer::Terms }

  attr_hash_accessor *Spree::Offers::ParamsProcessor::AllFields

  class << self
    def model_name
      ActiveModel::Name.new self, nil, "offer_edit_form"
    end
  end

  def initialize(attributes={})
    @attributes = attributes
  end

  def country
    @attributes[:country] = Spree::Country.normalize @attributes[:country]
  end

  def state
    @attributes[:state] = Spree::State.normalize @attributes[:state]
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def error_flash
    errors.full_messages.join ", "
  end

  def persisted?
    false
  end

  def to_key
    nil
  end

  def to_param
    nil
  end

  def to_partial_path
    "spree/offers/edit_form"
  end

  def offer_params
    Spree::Offers::ParamsProcessor.new(@attributes).offer_params
  end

end