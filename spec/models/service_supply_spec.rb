require 'spec_helper'

describe Spree::ServiceSupply do
  let(:supply) { ChineseFactory::ServiceSupply.mock }
  context 'factory' do
    it "should be a proper supply" do
      supply.should be_a Spree::ServiceSupply
    end
  end

  describe '#contract_with!' do
    let(:finalization) { ChineseFactory::Finalization.mock }
    let(:contract_make) { -> { supply.contract_with! finalization } }
    it "should create a service contract" do
      contract_make.should change(Spree::ServiceContract, :count).by(1)
    end
    it "should create a service contract that binds a finalization to a finalization" do
      contract = contract_make.call
      contract.recipient.should eq finalization
      contract.provider.should eq supply.shop
    end
  end
end