class Itps::Admins::InboundTransfers::EscrowsValidator < ActiveModel::Validator
  def validate(model)
    @model = model
    model.escrow_ids.each do |escrow_id|
      _push_error "#{escrow_id} cannot be found" if _no_such_id? escrow_id
      _push_error :already_expired if _escrow_expired? escrow_id
    end
    @model
  end

  private

  def _push_error(key)
    @model.errors.add :escrow_id_by_commas, key
  end

  def _no_such_id?(id)
    !Itps::Escrow.exist_by_bullshit_id?(id)
  end

  def _escrow_expired?(id)
    Itps::Escrow.find_by_bullshit_id(id).try(:expired_or_archived?)
  end

end