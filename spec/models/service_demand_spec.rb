require 'spec_helper'

describe Spree::ServiceDemand do
  let(:demand) { ChineseFactory::ServiceDemand.mock }
  context 'factory' do
    it "should be a proper demand" do
      demand.should be_a Spree::ServiceDemand
    end
  end

  describe '#contract_with!' do
    let(:shop) { ChineseFactory::Shop.mock }
    let(:contract_make) { -> { demand.contract_with! shop } }
    it "should create a service contract" do
      contract_make.should change(Spree::ServiceContract, :count).by(1)
    end
    it "should create a service contract that binds a finalization to a shop" do
      contract = contract_make.call
      contract.recipient.should eq demand.finalization
      contract.provider.should eq shop
    end
  end
end