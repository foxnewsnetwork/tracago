class Itps::Escrows::Step < ActiveRecord::Base
  belongs_to :escrow,
    class_name: 'Itps::Escrow'
  has_many :documents,
    class_name: 'Itps::Escrows::Document'
  has_many :approved_documents,
    -> { approved },
    class_name: 'Itps::Escrows::Document'
  has_many :rejected_documents,
    -> { rejected },
    class_name: 'Itps::Escrows::Document'
  before_validation :_create_permalink, :_establish_position

  def status
    return :completed if completed?
    return :waiting_documents if waiting_documents?
    return :rejected if rejected_documents?
    return :needs_approval if needs_approval?
    return :standby
  end

  def required_documents_presentation
    p = documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def approved_documents_presentation
    p = approved_documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def rejected_documents_presentation
    p = rejected_documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def completed?
    completed_at.present?
  end

  def waiting_documents?
    documents.any?(&:waiting_upload?)
  end

  def rejected_documents?
    documents.any?(&:rejected?)
  end

  def needs_approval?
    documents.all?(&:approved?) && !completed?
  end

  private
  def _establish_position
    self.position = escrow.last_step.try(:position).to_i + 1
  end

  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}"
  end

  def _scrambled_datekey
    [DateTime.now, escrow.id].map(&:to_i).map(&:to_alphabet).join("-step-")
  end
end