require 'spec_helper'

describe Spree::ServiceContract do
  context 'factory' do
    let(:contract) { ChineseFactory::ServiceContract.mock }
    context 'validity' do
      subject { contract }
      specify { should be_a Spree::ServiceContract }
      specify { should be_valid }
    end
    context 'provider' do
      subject { contract.provider }
      specify { should be_a Spree::Shop }
    end
    context 'recipient' do
      subject { contract.recipient }
      specify { should be_a Spree::Finalization }
    end
    context 'serviceable' do
      subject { contract.serviceable }
      specify { should be_a Spree::Serviceable }
    end
  end 
end