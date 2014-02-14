class CreateItpsEscrowsFilesDocuments < ActiveRecord::Migration
  def change
    create_table :itps_escrows_files_documents do |t|
      t.references :file, index: true
      t.references :document, index: true
    end
  end
end
