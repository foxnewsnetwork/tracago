class Spree::Listings::GeographicValidator < ActiveModel::Validator
  def validate(model)
    errors.add :state, model.state if _bad_state? model.state
    errors.add :country, model.country if _bad_country? model.country
  end

  private

  def _bad_state?(state)
    return if state.blank?
    Spree::State.normalize(state).blank?
  end

  def _bad_country?(country)
    return if country.blank?
    Spree::Country.normalize(country).blank?
  end
end