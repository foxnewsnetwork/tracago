class Spree::Finalizations::Serviceables::Trucks::GeographicValidator < ActiveModel::Validator

  def validate(model)
    model.errors.add :start_state, :does_not_exist if _bad_state? model.start_state
    model.errors.add :start_country, :does_not_exist if _bad_country? model.start_country
    model.errors.add :finish_state, :does_not_exist if _bad_state? model.finish_state
    model.errors.add :finish_country, :does_not_exist if _bad_country? model.finish_country
  end

  private

  def _bad_state?(state)
    Spree::State.normalize(state).blank?
  end

  def _bad_country?(country)
    Spree::Country.normalize(country).blank?
  end

end