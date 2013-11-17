class Spree::Addresses::Validator < ActiveModel::Validator

  def validate(model)
    state_validate(model)
  end

  private

  def state_validate(model)
    # Skip state validation without country (also required)
    # or when disabled by preference
    return if model.country.blank? || !Spree::Config[:address_requires_state]
    return unless model.country.states_required

    # ensure associated state belongs to country
    if model.state.present?
      if model.state.country == model.country
        model.state_name = nil #not required as we have a valid state and country combo
      else
        if model.state_name.present?
          model.state = nil
        else
          model.errors.add(:state, :invalid)
        end
      end
    end

    # ensure state_name belongs to country without states, or that it matches a predefined state name/abbr
    if model.state_name.present?
      if model.country.states.present?
        states = model.country.states.find_all_by_name_or_abbr(state_name)

        if states.size == 1
          model.state = states.first
          model.state_name = nil
        else
          model.errors.add(:state, :invalid)
        end
      end
    end

    # ensure at least one state field is populated
    model.errors.add :state, :blank if model.state.blank? && model.state_name.blank?
  end
end