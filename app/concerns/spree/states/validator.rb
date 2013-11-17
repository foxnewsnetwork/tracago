class Spree::States::Validator < ActiveModel::Validator
  def validate(model)
    if _normalize_state(model).blank?
      model.errors.add :state, "#{_normalize_state_attribute(model)} doesn't exist"
    end
  end

  private

  def _state_key(model)
    return :state if model.respond_to? :state
    return :state_id if model.respond_to? :state_id
  end

  def _normalize_state(model)
    Spree::State.normalize _normalize_state_attribute model
  end

  def _normalize_state_attribute(model)
    model.read_attribute_for_validation _state_key model
  end
end