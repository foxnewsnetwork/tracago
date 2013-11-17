class Spree::Countries::Validator < ActiveModel::Validator
  def validate(model)
    if _normalize_country(model).blank?
      model.errors.add :country, "#{_normalize_country_attribute(model)} doesn't exist"
    end
  end

  private

  def _country_key(model)
    return :country if model.respond_to? :country
    return :country_id if model.respond_to? :country_id
  end

  def _normalize_country(model)
    Spree::Country.normalize _normalize_country_attribute model
  end

  def _normalize_country_attribute(model)
    model.read_attribute_for_validation _country_key model
  end
end