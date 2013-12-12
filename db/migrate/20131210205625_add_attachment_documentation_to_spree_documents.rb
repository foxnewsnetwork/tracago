class AddAttachmentDocumentationToSpreeDocuments < ActiveRecord::Migration
  def self.up
    change_table :spree_documents do |t|
      t.attachment :documentation
    end
  end

  def self.down
    drop_attached_file :spree_documents, :documentation
  end
end
