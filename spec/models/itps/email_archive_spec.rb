# == Schema Information
#
# Table name: itps_email_archives
#
#  id            :integer          not null, primary key
#  mailer_name   :string(255)      not null
#  mailer_method :string(255)      not null
#  destination   :string(255)      not null
#  origination   :string(255)
#  subject       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Itps::EmailArchive do
  before do
    @escrow = JewFactory::Escrow.mock
    @escrow.payment_party_agree!
  end
  context 'serialized objects' do
    it 'should have created serialzied objects also' do
      expect do
        Itps::EscrowMailer.single_ready_email(@escrow)
      end.to change(Itps::EmailArchives::SerializedObject, :count).by(1)
    end
  end
  describe '#to_mail!' do
    before do
      @mail = Itps::EscrowMailer.single_ready_email(@escrow)
      @archive = Itps::EmailArchive.last
    end
    let(:object_params) do
      {
        name_of_model: 'Escrow',
        variable_namekey: :escrow,
        external_model_id: @escrow.id
      }
    end
    it 'should create the exact same email from the archive' do
      @archive.to_mail!.should eq @mail
    end
    it 'should create serialized objects instead' do
      expect do
        @archive.to_mail!
      end.to change(Itps::EmailArchives::SerializedObject, :count).by 1
    end
    it 'should create another archive' do
      expect do
        @archive.to_mail!
      end.to change(Itps::EmailArchive, :count).by(1)
    end
  end
end
