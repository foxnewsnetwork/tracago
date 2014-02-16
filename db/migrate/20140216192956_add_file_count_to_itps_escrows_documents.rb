class AddFileCountToItpsEscrowsDocuments < ActiveRecord::Migration
  def change
    add_column :itps_escrows_documents, :file_count, :integer, null: false, default: 0
  end
end
