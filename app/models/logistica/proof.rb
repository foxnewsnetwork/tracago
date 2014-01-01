# == Schema Information
#
# Table name: logistica_proofs
#
#  id            :integer          not null, primary key
#  step_id       :integer
#  provable_id   :integer
#  provable_type :string(255)
#  title         :string(255)
#  permalink     :string(255)
#  expires_at    :datetime
#  rejected_at   :datetime
#  approved_at   :datetime
#  deleted_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Logistica::Proof < ActiveRecord::Base
  belongs_to :step, class_name: 'Logistica::Step'
  belongs_to :provable, polymorphic: true
  before_validation :_set_permalink
  scope :no_documents,
    -> { where "#{self.table_name}.provable_id is null" }
  scope :has_documents,
    -> { where "#{self.table_name}.provable_id is not null" }
  scope :approved,
    -> { where "#{self.table_name}.approved_at is not null" }
  scope :not_approved,
    -> { where "#{self.table_name}.approved_at is null" }

  def waiting_document?
    provable.blank?
  end

  def processing_approval?
    provable.present? && !(rejected? || approved? || expired?)
  end

  def rejected?
    !approved? && rejected_at.present?
  end

  def approved?
    approved_at.present?
  end

  def expired?
    !(rejected? || approved?) && Time.now > expires_at.present?
  end


  private
  def _set_permalink
    self.permalink ||= title.to_s.to_url
  end
end
