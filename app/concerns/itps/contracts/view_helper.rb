class Itps::Contracts::ViewHelper

  attr_hash_reader *Itps::Drafts::FormHelper::Fields
  attr_reader :draft, :attributes, :contract
  delegate :items, 
    :punishments,
    :packing_weight_punishments,
    :container_count_punishments,
    :minimum_packing_weight_before_cancel,
    :minimum_container_count_before_cancel,
    :minimum_packing_weight_before_punishment,
    :minimum_container_count_before_punishment,
    to: :draft
  def initialize(contract)
    @contract = contract
    @draft = contract.draft
    @attributes = @draft.parsed_hash
  end

  def punish_weight?
    minimum_average_weight.present? || packing_weight_punishments.present?
  end

  def punish_containers?
    minimum_containers.present? || container_count_punishments.present?
  end

  def seller_full_address
    [seller_address1,
        seller_address2,
        seller_city,
        seller_province,
        seller_country].reject(&:blank?).join(", ")
  end

  def buyer_full_address
    [buyer_address1,
        buyer_address2,
        buyer_city,
        buyer_province,
        buyer_country].reject(&:blank?).join(", ")
  end

  def total_items_cost
    draft.total_cost
  end

  def incoterm_responsibilities
    Itps::Drafts::International::IncotermDuties.zip Itps::Drafts::International::IncotermsHash[price_terms]
  end
end