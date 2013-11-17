class Spree::Listings::MaterialValidator < ActiveModel::Validator
  def validate(model)
    if Spree::Material.find_by_id(model.read_attribute_for_validation :material).blank?
      model.errors.add :material, "#{model.read_attribute_for_validation :material} doesn't exist"
    end
  end
end