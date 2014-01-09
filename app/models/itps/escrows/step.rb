# == Schema Information
#
# Table name: itps_escrows_steps
#
#  id           :integer          not null, primary key
#  escrow_id    :integer          not null
#  title        :string(255)      not null
#  permalink    :string(255)      not null
#  instructions :text             not null
#  completed_at :datetime
#  position     :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

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
    return :waiting_final_approval if waiting_final_approval?
    return :error
  end

  def full_presentation
    "Step #{position} -- #{title}"
  end

  def swap_down!
    swap_position_with! one_step_down if one_step_down.present?
  end

  def one_step_down
    escrow.steps.find_by_position(position + 1)
  end

  def swap_up!
    swap_position_with! one_step_up if one_step_up.present?
  end

  def one_step_up
    escrow.steps.find_by_position(position - 1)
  end

  def swap_position_with!(step)
    p = position
    update(position: step.position) && step.update(position: p)
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

  def complete!
    update_column 'completed_at', DateTime.now
  end

  def completed?
    _n(completed_at) > _n(updated_at)
  end

  def waiting_documents?
    documents.any?(&:waiting_upload?)
  end

  def rejected_documents?
    documents.any?(&:rejected?)
  end

  def needs_approval?
    documents.any?(&:waiting_approval?) && !completed?
  end

  def waiting_final_approval?
    documents.all(&:approved?) && !completed?
  end

  private
  def _n(datetime)
    Spree::DateTime.normalize_against_never datetime
  end

  def _establish_position
    self.position = escrow.last_step.try(:position).to_i + 1
  end

  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}".to_url
  end

  def _scrambled_datekey
    [DateTime.now, escrow.id].map(&:to_i).map(&:to_alphabet).join("-step-")
  end
end
