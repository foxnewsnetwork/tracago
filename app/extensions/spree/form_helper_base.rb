class Spree::FormHelperBase
  include ActiveModel::Validations
  class << self
    def model_name_suffix
      self.to_s.split("::")[-2] || "form_helper"
    end

    def model_name
      ActiveModel::Name.new self, nil, model_name_suffix
    end
  end
  def initialize(attributes={})
    @attributes = attributes
  end

  def persisted?
    false
  end

  def to_partial_path
    nil
  end

  def to_param
    nil
  end

  def to_key
    nil
  end
end