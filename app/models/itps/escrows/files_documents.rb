# == Schema Information
#
# Table name: itps_escrows_files_documents
#
#  id          :integer          not null, primary key
#  file_id     :integer
#  document_id :integer
#

class Itps::Escrows::FilesDocuments < ActiveRecord::Base
  self.table_name = 'itps_escrows_files_documents'
  belongs_to :file,
    class_name: 'Itps::File'
  belongs_to :document,
    class_name: 'Itps::Escrows::Document',
    touch: true

  before_create :_document_attachment_status_update
  before_destroy :_destroy_document_attachment_status_update

  private

  def _document_attachment_status_update
    document.update file_count: (document.file_count.to_i + 1)
  end

  def _destroy_document_attachment_status_update
    document.update file_count: (document.file_count.to_i - 1)
  end


end
