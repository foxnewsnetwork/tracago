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

class Logistica::Step < ActiveRecord::Base
  has_many :proofs, class_name: 'Logistica::Proof'
  has_many :needed_proofs,
    -> { no_documents },
    class_name: 'Logistica::Proof'
  has_many :uploaded_proofs,
    -> { has_documents.not_approved },
    class_name: 'Logistica::Proof'
  has_many :approved_proofs,
    -> { has_documents.approved },
    class_name: 'Logistica::Proof'
  belongs_to :plan, class_name: 'Logistica::Plan'
  before_validation :_set_step_type, :_set_presentation

  def downcast
    _downcast_class.find id
  end

  def required_actions
    []
  end

  def needed_documents_presentation
    s = needed_proofs.map(&:title).join(", ")
    s.present? ? s : I18n.t(:none)
  end

  def uploaded_documents_presentation
    s = uploaded_proofs.map(&:title).join(", ")
    s.present? ? s : I18n.t(:none)
  end

  def approved_documents_presentation
    s = approved_proofs.map(&:title).join(", ")
    s.present? ? s : I18n.t(:none)
  end


  def status
    return :expired           if expired?
    return :rejected          if rejected?
    return :approved          if approved?
    return :processing_proof     if processing_proof?
    return :waiting_proof     if waiting_proof?
    return :waiting_approval if waiting_approval?
    return :unknown
  end

  def expired?
    expires_at.present? && Time.now > expires_at
  end

  def rejected?
    !approved? && rejected_at.present?
  end

  def approved?
    approved_at.present?
  end

  def waiting_proof?
    proofs.any?(&:waiting_document?)
  end

  def waiting_approval?
    !(expired? || rejected? || approved?)
  end

  def processing_proof?
    proofs.any?(&:processing_approval?)
  end

  private
  def _downcast_class
    Logistica::Steps.const_get step_type.to_s.camelcase
  end

  def _set_step_type
    self.step_type = permalink
  end

  def _set_presentation
    self.presentation ||= permalink.split("_").join(" ").capitalize
  end
end
