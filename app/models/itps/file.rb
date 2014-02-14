# == Schema Information
#
# Table name: itps_files
#
#  id                 :integer          not null, primary key
#  permalink          :string(255)      not null
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Itps::File < ActiveRecord::Base
  Image = 'image'
  self.table_name = 'itps_files'
  has_one :relationship,
    class_name: 'Itps::Escrows::FilesDocuments',
    dependent: :destroy
  has_one :document,
    through: :relationship,
    class_name: 'Itps::Escrows::Document'

  has_attached_file :image,
    url: '/itps/files/:id/:access_token/:basename.:extension',
    path: ':rails_root/public/itps/files/:id/:access_token/:basename.:extension'

  before_create :_create_permalink

  def picture?
    Image == image_content_type.to_s.split('/').first
  end

  private

  def _create_permalink
    if permalink.blank?
      self.permalink = [rand(999999), DateTime.now.to_i].map(&:to_alphabet).join("-")
    end
  end
end
