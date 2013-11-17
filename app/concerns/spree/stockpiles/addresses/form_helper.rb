class Spree::Stockpiles::Addresses::FormHelper
  delegate :valid?, 
    :errors, 
    :to_param, 
    :persisted?, 
    :to_key, 
    :address1,
    :address2,
    :city,
    :zipcode,
    :state,
    :country,
    to: :_model


  class << self
    def model_name
      ActiveModel::Name.new self, nil, "address_form_helper"
    end
  end

  def initialize(attributes={}, stockpile=nil)
    @stockpile, @attributes = stockpile, attributes
  end

  def address_params
    _model.attributes.symbolize_keys
  end

  def flash_message
    return errors.full_messages.join(", ") unless valid?
  end

  def to_partial_path
    Spree.r.stockpile_addresses_path stockpile
  end

  def stockpile
    @stockpile ||= OpenStruct.new.tap { |o| o.id = 0 }
  end

  private

  def _model
    @model ||= Spree::Address.new _processed_params
  end

  def _processed_params
    @processed_params ||= Spree::Stockpiles::Addresses::ParamsProcessor.new(@attributes).params
  end

end