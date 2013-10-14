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