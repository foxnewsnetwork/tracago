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
#  previous_id  :integer
#  class_name   :string(255)
#  memo         :text
#

class Itps::Escrows::Step < ActiveRecord::Base
  AllTypes = ['payin_step', 'payout_step'].freeze

  class AbandonedFeature < StandardError; end
  class << self
    def swap_positions(stepa, stepb)
      raise AbandonedFeature, "Abandoned this feature on Jan 10, 2014"
      _move_stepb_into_stepa stepa, stepb
      _move_stepb_into_stepa stepb, stepa
    end

    private
    def _move_stepb_into_stepa(stepa, stepb)
      raise AbandonedFeature, "Abandoned this feature on Jan 10, 2014"
      stepb.update previous_step: stepa.previous_step
      stepa.next_step.update previous_step: stepb if stepa.next_step.present?
    end
  end
  belongs_to :escrow,
    class_name: 'Itps::Escrow'
  belongs_to :previous_step,
    class_name: 'Itps::Escrows::Step',
    foreign_key: 'previous_id'
  has_one :next_step,
    class_name: 'Itps::Escrows::Step',
    foreign_key: 'previous_id'
  has_many :documents,
    class_name: 'Itps::Escrows::Document'
  has_many :approved_documents,
    -> { approved },
    class_name: 'Itps::Escrows::Document'
  has_many :rejected_documents,
    -> { rejected },
    class_name: 'Itps::Escrows::Document'
  before_create :_create_permalink, :_establish_position
  
  delegate :edit_mode?,
    to: :escrow
  def downcast
    return Itps::Escrows::PayStep.find id if pay_step?
    self
  end

  # Hey, why don't we use meta-programming to automate bool methods for step type?
  # Because we don't need to and using meta-programming without absolutely good reason
  # causes endless cancer in the greater scheme of things
  def payin_step?
    'payin_step' == class_name
  end 

  def payout_step?
    'payout_step' == class_name
  end

  def pay_step?
    'pay_step' == class_name
  end

  def memo_markedown
    BlueClothe.new(memo).to_html.html_safe
  end

  def status
    return :edit_mode if edit_mode?
    return :completed if completed?
    return :waiting_documents if waiting_documents?
    return :rejected if rejected_documents?
    return :needs_approval if needs_approval?
    return :waiting_final_approval if waiting_final_approval?
    return :error
  end

  def reference_id
    previous_id
  end

  def full_presentation
    "Step #{position} -- #{title}"
  end

  def swap_down!
    raise AbandonedFeature, "Abandoned this feature on Jan 10, 2014"
    swap_position_with! next_step if next_step.present?
  end

  def swap_up!
    raise AbandonedFeature, "Abandoned this feature on Jan 10, 2014"
    swap_position_with! previous_step if previous_step.present?
  end

  def swap_position_with!(step)
    raise AbandonedFeature, "Abandoned this feature on Jan 10, 2014"
    p = position
    update(position: step.position) && step.update(position: p)
    self.class.swap_positions(stepa, stepb)
  end

  alias_method :all_documents, :documents
  alias_method :all_approved_documents, :approved_documents
  alias_method :all_rejected_documents, :rejected_documents

  def required_documents_presentation
    p = all_documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def approved_documents_presentation
    p = all_approved_documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def rejected_documents_presentation
    p = all_rejected_documents.map(&:title).join(", ")
    p.present? ? p : I18n.t(:none)
  end

  def complete!
    update_column 'completed_at', DateTime.now
  end

  def completed?
    _n(completed_at) > _n(updated_at)
  end

  def waiting_documents?
    all_documents.any?(&:waiting_upload?)
  end

  def rejected_documents?
    all_documents.any?(&:rejected?)
  end

  def needs_approval?
    all_documents.any?(&:waiting_approval?) && !completed?
  end

  def waiting_final_approval?
    all_documents.all(&:approved?) && !completed?
  end

  private
  def _n(datetime)
    Spree::DateTime.normalize_against_never datetime
  end

  def _establish_position
    self.position = escrow.last_step.try(:position).to_i + 1
    self.previous_id = escrow.last_step.try :id
  end

  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}".to_url
  end

  def _scrambled_datekey
    [DateTime.now, escrow.id].map(&:to_i).map(&:to_alphabet).join("-step-")
  end
end
