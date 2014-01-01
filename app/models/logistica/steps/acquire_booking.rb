class Logistica::Steps::AcquireBooking < Logistica::Step
  self.table_name = 'logistica_steps'
  class << self
    def related_document_names
      [:booking_confirmation]
    end
  end

  def proofs_with_defaults
    return _populate_proofs if proofs_without_defaults.blank?
    return proofs_without_defaults
  end
  alias_method_chain :proofs, :defaults

  private
  def _populate_proofs
    self.class.related_document_names.map do |name|
      proofs_without_defaults.find_or_create_by title: name
    end
  end
end