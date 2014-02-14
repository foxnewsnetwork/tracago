# == Schema Information
#
# Table name: itps_escrows_documents
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  description                :text
#  permalink                  :string(255)      not null
#  approved_at                :datetime
#  rejected_at                :datetime
#  step_id                    :integer          not null
#  created_at                 :datetime
#  updated_at                 :datetime
#  attached_file_file_name    :string(255)
#  attached_file_content_type :string(255)
#  attached_file_file_size    :integer
#  attached_file_updated_at   :datetime
#

class Itps::Escrows::Document < ActiveRecord::Base
  IdBuffer = 18761
  belongs_to :step,
    touch: true,
    class_name: 'Itps::Escrows::Step'
  has_one :escrow,
    through: :step,
    class_name: 'Itps::Escrow'
  has_many :relationships,
    class_name: 'Itps::Escrows::FilesDocuments'
  has_many :files,
    through: :relationships,
    class_name: 'Itps::File'
  before_validation :_create_permalink

  scope :has_attachment,
    -> { where "#{self.table_name}.attached_file_file_name is not null" }
  scope :has_file_attachments,
    -> { joins(:relationships).where "#{self.table_name}.id = relationships.batch_document_id" }
  scope :not_approved,
    -> { where "#{self.table_name}.approved_at is null or #{self.table_name}.approved_at < #{self.table_name}.rejected_at"}
  scope :waiting_approval,
    -> { has_attachment.not_approved }
  scope :approved,
    -> { where("#{self.table_name}.approved_at is not null") }
  scope :rejected,
    -> { where("#{self.table_name}.rejected_at is not null" )}

  has_attached_file :attached_file,
    url: '/itps/escrows/documents/:id/:access_token/:basename.:extension',
    path: ':rails_root/public/itps/escrows/documents/:id/:access_token/:basename.:extension'

  delegate :edit_mode?,
    to: :step

  validates :title,
    :permalink,
    :step,
    presence: true

  def status
    return :edit_mode if edit_mode?
    return :approved if approved?
    return :rejected if rejected?
    return :waiting_upload if waiting_upload?
    return :waiting_approval if waiting_approval?
    return :error
  end

  def full_presentation
    "#{title} -- #{IdBuffer + id}"
  end

  def waiting_approval?
    _n(updated_at) > _n(approved_at) && _n(updated_at) > _n(rejected_at)
  end

  def waiting_upload?
    attached_file.blank?
  end

  def approve!
    update_column 'approved_at', DateTime.now
  end

  def reject!
    update_column 'rejected_at', DateTime.now
  end

  def rejected?
    !waiting_approval? && _n(rejected_at) > _n(approved_at)
  end

  def approved?
    !waiting_approval? && _n(approved_at) > _n(rejected_at)
  end

  private
  def _n(datetime)
    Spree::DateTime.normalize_against_never datetime
  end

  def _create_permalink
    self.permalink ||= "#{title.to_s.to_url}-#{_scrambled_datekey}".to_url
  end

  def _scrambled_datekey
    [step.id, Time.now].map(&:to_i).map(&:to_alphabet).join("-doc-")
  end
end
