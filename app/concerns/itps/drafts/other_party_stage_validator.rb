class Itps::Drafts::OtherPartyStageValidator < ActiveModel::Validator
  RequiredFields = [
    :seller_email,
    :seller_company_name,
    :seller_address1,
    :seller_city,
    :seller_province,
    :seller_country
  ].freeze
  def validate(model)
    return if model.stages[:other_party].blank?
    RequiredFields.map do |field|
      model.errors.add field, :blank if model.send(field).blank?
    end.select { |field| /email/ =~ field.to_s }.map do |field|
      model.errors.add field, :wrong_format if model.send(field).to_s =~ Devise.email_regexp
    end
  end
end