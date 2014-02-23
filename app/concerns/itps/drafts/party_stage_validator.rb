class Itps::Drafts::PartyStageValidator < ActiveModel::Validator
  RequiredFields = [
    :buyer_email,
    :buyer_company_name,
    :buyer_address1,
    :buyer_city,
    :buyer_province,
    :buyer_country
  ].freeze
  def validate(model)
    return if model.stages[:party].blank?
    RequiredFields.map do |field|
      model.errors.add field, :blank if model.send(field).blank?
    end.select { |field| /email/ =~ field.to_s }.map do |field|
      model.errors.add field, :wrong_format if model.send(field).to_s =~ Devise.email_regexp
    end
  end
end