class Itps::Drafts::FormHelper < Spree::FormHelperBase
  PartyFields = [
    :buyer_email, 
    :buyer_company_name,
    :buyer_address1,
    :buyer_address2,
    :buyer_city,
    :buyer_province,
    :buyer_country
  ].freeze
  SellerFields = [
    :seller_email,
    :seller_company_name,
    :seller_address1,
    :seller_address2,
    :seller_city,
    :seller_province,
    :seller_country
  ].freeze
  CommodityFields = [
    :price_terms,
    :latest_shipment_date
  ].freeze
  DocumentFields = [
    :preloading_pictures,
    :weight_ticket,
    :loading_pictures,
    :bill_of_lading,
    :packing_list,
    :invoice
  ].freeze
  Fields = PartyFields + SellerFields + CommodityFields + DocumentFields
  attr_reader :draft, :account
  attr_accessor :attributes
  attr_hash_accessor *Fields
  validates_with Itps::Drafts::PartyStageValidator
  validates_with Itps::Drafts::OtherPartyStageValidator
  validates_with Itps::Drafts::CommodityStageValidator
  
  delegate :items, to: :draft

  def draft=(draft)
    self.account = draft.account
    self.attributes = draft.parsed_hash.symbolize_keys.permit(*Fields)
    @draft = draft
  end
  

  def account=(account)
    self.buyer_company_name = account.party.company_name
    self.buyer_email = account.email
    @account = account
  end

  def document_attributes=(hash)
    @attributes = attributes.symbolize_keys.merge hash.symbolize_keys
    _completed! :document
  end

  def commodity_attributes=(hash)
    @attributes = attributes.symbolize_keys.merge hash.symbolize_keys
    _completed! :commodity
  end

  def party_attributes_as_buyer=(hash)
    @attributes = attributes.symbolize_keys.merge hash.symbolize_keys
    _completed! :party
  end

  def sellers_attributes_as_buyer=(hash)
    @attributes = attributes.symbolize_keys.merge hash.symbolize_keys
    _completed! :other_party
  end

  def update_success?
    
    @update_result.is_a?(Itps::Draft) && @update_result.persisted?
  end

  def update_failed?
    false == @update_result
  end

  def draft!
    if draft.present? && draft.persisted?
      @update_result = valid? && draft.update_from_hash!(attributes)
    else
      valid? && (@draft = account.drafts.create_from_hash! attributes)
    end
  end

  def stages
    @stages ||= ActiveSupport::OrderedHash.new
  end

  private
  def _completed!(stage_name)
    stages[stage_name] = true
  end
end