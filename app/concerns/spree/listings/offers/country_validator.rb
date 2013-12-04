class Spree::Listings::Offers::CountryValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    _country_must_exist!
  end

  private
  
  def _country_must_exist!
    return if _country_exists?
    @model.errors.add :country, :no_such_country
  end

  def _country_exists?
    Spree::Country.find_by_romanized_name(@model.country).present?
  end
end
