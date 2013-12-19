class Itps::Escrows::Document < ActiveRecord::Base
  belongs_to :step,
    class_name: 'Itps::Escrows::Step'
  before_validation :_create_permalink

  scope :approved,
    -> { where("#{self.table_name}.approved_at is not null") }
  scope :rejected,
    -> { where("#{self.table_name}.rejected_at is not null" )}
  has_attached_file :attached_file,
    url: '/itps/escrows/documents/:id/:access_token/:basename.:extension',
    path: ':rails_root/public/itps/escrows/documents/:id/:access_token/:basename.:extension'

  def status
    return :rejected if rejected?
    return :approved if approved?
    return :waiting_upload if waiting_upload?
    return :waiting_approval
  end


  def waiting_upload?
    attached_file.blank?
  end

  def rejected?
    rejected_at.present?
  end

  def approved?
    approved_at.present?
  end


  private
  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}"
  end

  def _scrambled_datekey
    [step.id, Time.now].map(&:to_i).map(&:to_alphabet).join("-doc-")
  end
end