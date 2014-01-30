class Itps::Escrows::Escrows::FormHelper < Itps::Accounts::Escrows::EscrowFormHelper
  Fields = [
    :other_party_email,
    :other_party_company_name,
    :my_role
  ]
  attr_hash_accessor *Fields
  attr_accessor :escrow
  validates :escrow,
    presence: true

  def escrow!
    @cloned_escrow ||= _create_escrow.tap { |e| e.copy_steps_from! escrow }
  end

  def create_success?
    @create_result ||= valid? && escrow_created? && steps_cloned?
  end

  def escrow_created?
    escrow!.present? && @cloned_escrow.persisted?
  end

  def steps_cloned?
    _cloned_steps_count_match? && _cloned_steps_content_match?
  end

  def create_failed?
    !create_success?
  end

  private
  def _create_escrow
    Itps::Escrow.create! service_party: _service_party,
      payment_party: _payment_party,
      draft_party: _draft_party
  end

  def _cloned_steps_count_match?
    @cloned_escrow.steps.count == escrow.steps.count
  end

  def _cloned_steps_content_match?
    @cloned_escrow.steps.zip(escrow.steps).map do |step_pair|
      step_pair.first.title == step_pair.second.title && step_pair.first.instructions == step_pair.second.instructions
    end.all?
  end

end