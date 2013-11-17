class Spree::Finalizations::Serviceables::Trucks::FormHelper
  Fields = [
    :start_address1,
    :start_address2,
    :start_city,
    :start_state,
    :start_country,
    :start_zipcode,
    :finish_address1,
    :finish_address2,
    :finish_city,
    :finish_state,
    :finish_country,
    :finish_zipcode,
    :pickup_at,
    :arrive_at,
    :usd_price
  ]
  include ActiveModel::Validations
  validates_with Spree::Finalizations::Serviceables::Trucks::CausalityValidator
  validates_with Spree::Finalizations::Serviceables::Trucks::GeographicValidator
  attr_hash_accessor *Fields

  class << self
    def model_name
      ActiveModel::Name.new self, nil, "serviceable"
    end
  end

  def initialize(attributes={})
    @attributes = attributes
  end

  def truck_params
    _core_hash.merge _relations_hash
  end

  def to_param
    nil
  end

  def persisted?
    false
  end

  def to_partial_path
    "finalizations/serviceables/trucks"
  end

  def to_key
    nil
  end

  private

  def _core_hash
    @attributes.permit(:pickup_at, :arrive_at, :usd_price)
  end

  def _relations_hash
    { origination: _origination, destination: _destination }
  end

  def _origination
    @origination ||= Spree::Address.find_roughly_or_create_by _process_keys _raw_origination_params
  end

  def _destination
    @destination ||= Spree::Address.find_roughly_or_create_by _process_keys _raw_destination_params
  end

  def _process_keys(params)
    params.key_map do |key|
      key.to_s.split("_").last.to_sym
    end
  end

  def _raw_destination_params
    @attributes.permit :finish_zipcode,
      :finish_city,
      :finish_country,
      :finish_state,
      :finish_address1,
      :finish_address2
  end

  def _raw_origination_params
    @attributes.permit :start_zipcode,
      :start_city,
      :start_country,
      :start_state,
      :start_address1,
      :start_address2
  end

end
