class AddAttachmentImageToItpsFiles < ActiveRecord::Migration
  def self.up
    change_table :itps_files do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :itps_files, :image
  end
end
