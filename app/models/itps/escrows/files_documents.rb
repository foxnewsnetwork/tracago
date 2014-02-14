# == Schema Information
#
# Table name: itps_escrows_files_batch_documents
#
#  id                :integer          not null, primary key
#  file_id           :integer
#  batch_document_id :integer
#

class Itps::Escrows::FilesDocuments < ActiveRecord::Base
  self.table_name = 'itps_escrows_files_documents'
  belongs_to :file,
    class_name: 'Itps::File'
  belongs_to :document,
    class_name: 'Itps::Escrows::Document'
end
