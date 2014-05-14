require 'spec_helper'

describe Itps::Contracts::Agreements::Interactor do
  describe '#agree!' do
    let(:interactor) { Itps::Contracts::Agreements::Interactor.new(@contract) }
    let(:interaction) { interactor.tap { |i| i.attributes = @params } }
    let(:result) { interaction.agree! }
    before do
      @contract = JewFactory::Contract.mock
      @params = {
        agree: true,
        contract_text: Faker::Lorem.paragraph
      }
      @escrow = lambda { Itps::Contract.find(@contract.id).escrow }
      @steps = lambda { @escrow.call.steps }
    end
    it 'should be successful' do
      result.should be_success
    end
    it 'should create six steps' do
      expect { result }.to change(Itps::Escrows::Step, :count).by(7)
    end
    it 'should have steps that properly match the escrow' do
      result
      @steps.call.each do |step|
        step.escrow.should eq @escrow.call
      end
    end

  end
end