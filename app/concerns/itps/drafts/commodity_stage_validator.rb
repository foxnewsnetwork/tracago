class Itps::Drafts::CommodityStageValidator < ActiveModel::Validator
  def validate(model)
    return if model.stages[:commodity].blank?
    model.errors.add :price_terms, :blank if model.price_terms.blank?
    model.errors.add :price_terms, :nonsensical unless _price_terms_makes_sense? model.price_terms.to_s.strip
    model.errors.add :items, :blank if model.items.blank?
  end

  private

  def _price_terms_makes_sense?(terms)
    terms =~ /^(fas|cnf|cif|fob)[\s\w]+$/i ||
    terms =~ /^(e?xworks?|pickup)$/i
  end
end