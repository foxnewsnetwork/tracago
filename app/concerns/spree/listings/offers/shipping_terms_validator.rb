class Spree::Listings::Offers::ShippingTermsValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    _exworks_should_not_have_address
    _other_terms_require_address
  end

  private

  def _exworks_should_not_have_address
    return unless _exworks?
    _has_country! unless _missing_country?
    _has_state!   unless _missing_state?
    _has_city!    unless _missing_city?
    _has_address! unless _missing_address?
  end

  def _other_terms_require_address
    return if _exworks?
    _missing_country! if _missing_country?
    _missing_state!   if _missing_state?
    _missing_city!    if _missing_city?
    _missing_address! if _missing_address?
  end

  def _exworks?
    @model.shipping_terms == Spree::Offer::EXWORKS
  end

  def _has_country!
    @model.errors.add :country, :has_content
  end

  def _has_state!
    @model.errors.add :state, :has_content
  end

  def _has_city!
    @model.errors.add :city, :has_content
  end

  def _has_address!
    @model.errors.add :address, :has_content
  end

  def _missing_country!
    @model.errors.add :country, :missing
  end

  def _missing_country?
    @model.country.blank?
  end

  def _missing_state!
    @model.errors.add :state, :missing
  end

  def _missing_state?
    @model.state.blank?
  end

  def _missing_city!
    @model.errors.add :city, :missing
  end

  def _missing_city?
    @model.city.blank?
  end

  def _missing_address!
    @model.errors.add :address1, :missing
  end

  def _missing_address?
    @model.address1.blank?
  end


end