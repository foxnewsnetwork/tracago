class Spree::EscrowStep < ActiveRecord::Base
  class BadStep < ::StandardError; end
  self.table_name = 'spree_escrow_steps'
  belongs_to :finalization,
    class_name: 'Spree::Finalization'

  has_many :rejected_documents,
    -> { rejected },
    as: :documentable,
    class_name: 'Spree::Document'

  has_many :documents,
    -> { not_rejected },
    as: :documentable,
    class_name: 'Spree::Document'

  before_validation :_set_permalink,
    :_default_step_type

  class << self
    def create_from_filename(hashes)
      processed_hashes = hashes.map do |hash|
        {
          finalization: hash[:finalization],
          presentation: _to_presentation(hash[:filename]),
          step_type: _to_step_type(hash[:filename])
        }
      end
      create! processed_hashes
    end

    def _to_presentation(filename)
      _to_step_type(filename).split("_").map(&:capitalize).join " "
    end

    def _to_step_type(filename)
      filename.split("/").last.split(".").first
    end
  end

  def position
    0
  end

  # cast down based on type
  def downcast
    raise BadStep, 'No step given' if step_type.blank?
    Spree::EscrowSteps.const_get(step_type.camelcase).find(id)
  end

  def complete?
    completed_at.present?
  end
  alias_method :approved?, :complete?

  def required_documents
    []
  end

  def missing_documents
    required_documents - documents.map(&:presentation)
  end

  def status
    return :complete if complete?
    return :rejected if rejected?
    return :missing if missing?
    return :active if previous_complete?
    return :waiting
  end

  def previous
    @previous ||= finalization.downcast_escrow_steps.find { |e| position == e.position + 1 }
  end

  def previous_complete?
    return true if previous.blank?
    return previous.complete?
  end

  def waiting?
    !(complete? || rejected? || missing?)
  end

  def rejected?
    rejected_documents.any?
  end

  def missing?
    missing_documents.any?
  end

  private

  def _set_permalink
    self.permalink = presentation.downcase.split.select { |word| word =~ /[a-z0-9]/ }.join "-"
  end

  def _default_step_type
    self.step_type ||= self.class.to_s.split("::").last.underscore
  end
end

# >summer
# >uncle owns a foot message shop in LA
# >get recruited to work
# >