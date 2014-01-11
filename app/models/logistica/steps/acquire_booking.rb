# == Schema Information
#
# Table name: logistica_steps
#
#  id           :integer          not null, primary key
#  plan_id      :integer
#  presentation :string(255)
#  permalink    :string(255)
#  step_type    :string(255)      not null
#  position     :integer          default(0), not null
#  notes        :text
#  expires_at   :datetime
#  rejected_at  :datetime
#  approved_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

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
