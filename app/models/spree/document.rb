class Spree::Document < ActiveRecord::Base
  self.table_name = 'spree_documents'

  scope :rejected,
    -> { where "#{self.table_name}.rejected_at is not null" }
  scope :not_rejected,
    -> { where "#{self.table_name}.rejected_at is null" }
  belongs_to :documentable,
    polymorphic: true 

  has_attached_file :documentation,
    default_url: '/spree/documents/missing.txt',
    url: '/spree/documents/:id/:access_token/:basename.:extension',
    path: ':rails_root/public/spree/documents/:id/:access_token/:basename.:extension'

  validates_attachment :documentation,
    presence: true,
    size: { in: 0..5.megabytes },
    content_type: { content_type: "application/pdf"}

  before_validation :_set_permalink

  private

  def _set_permalink
    self.permalink = presentation.downcase.split.select { |word| word =~ /[a-z0-9]/ }.join "-"
  end
end