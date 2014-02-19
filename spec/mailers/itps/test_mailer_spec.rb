require 'spec_helper'

describe Itps::TestMailer do
  describe '::generate_email_without_archiving' do
    before do
      @generate = lambda { Itps::TestMailer.generate_email_without_archiving :test_email, 'test@target.gov' }
    end
    it 'should not create an archive' do
      @generate.should_not change(Itps::EmailArchive, :count)
    end
    it 'should generate an email though' do
      @generate.call.should be_a Mail::Message
    end
  end
end