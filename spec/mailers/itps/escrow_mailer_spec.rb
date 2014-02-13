require 'spec_helper'

describe Itps::EscrowMailer do
  before do
    @escrow = JewFactory::Escrow.mock
  end
  describe '#single_ready_email' do
    before do
      @escrow.payment_party_agree!
    end
    it 'should create an element in the email archive after the delivery' do
      expect do
        Itps::EscrowMailer.single_ready_email(@escrow)
      end.to change(Itps::EmailArchive, :count).by(1)
    end
  end
  describe '#both_ready_email' do
    before do
      @escrow.payment_party_agree!
      @escrow.service_party_agree!
    end
    it 'should create an element in the email archive after the delivery' do
      expect do
        Itps::EscrowMailer.both_ready_email(@escrow)
      end.to change(Itps::EmailArchive, :count).by(1)
    end
  end
end