# == Schema Information
#
# Table name: spree_assets
#
#  id                      :integer          not null, primary key
#  viewable_id             :integer
#  viewable_type           :string(255)
#  attachment_width        :integer
#  attachment_height       :integer
#  attachment_file_size    :integer
#  position                :integer
#  attachment_content_type :string(255)
#  attachment_file_name    :string(255)
#  type                    :string(75)
#  attachment_updated_at   :datetime
#  alt                     :text
#

class ChineseFactory::Image
  class << self
    def mock
      Rack::Test::UploadedFile.new attributes[:filepath]
    end
    def attributes
      { filepath: Rails.root.join('spec','fixtures','images','biribiri.jpeg') }
    end
  end

end
