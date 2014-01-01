class AddExpiresAtApprovedAtToSpreeDocuments < ActiveRecord::Migration
  def change
    add_column :spree_documents, :expires_at, :datetime
    add_column :spree_documents, :approved_at, :datetime
  end
end
