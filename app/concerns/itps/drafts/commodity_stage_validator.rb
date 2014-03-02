class Itps::Drafts::CommodityStageValidator < ActiveModel::Validator
  def validate(model)
    return if model.stages[:commodity].blank?
    model.errors.add :price_terms, :blank if model.price_terms.blank?
    model.errors.add :price_terms, :nonsensical unless _price_terms_makes_sense? model 
    model.errors.add :days_seller_has_to_load, :nonsensical if _nonsensical_date? model
    model.errors.add :destination, :blank if _require_but_missing_destination? model
    model.errors.add :items, :blank if model.items.blank?
  end

  private
  def _nonsensical_date?(model)
    return false if model.days_seller_has_to_load.blank?
    1 > model.days_seller_has_to_load.to_i
  end

  def _price_terms_makes_sense?(model)
    Itps::Drafts::International::Incoterms.include? model.price_terms
  end

  def _require_but_missing_destination?(model)
    _require_destination?(model) && model.destination.blank?
  end

  def _require_destination?(model)
    model.price_terms != 'EXW'
  end

end