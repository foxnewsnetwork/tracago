class AddAttachmentAttachedFileToItpsEscrowsDocuments < ActiveRecord::Migration
  def self.up
    change_table :itps_escrows_documents do |t|
      t.attachment :attached_file
    end
  end

  def self.down
    drop_attached_file :itps_escrows_documents, :attached_file
  end
end
