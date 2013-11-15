require 'spec_helper'

describe Spree::Serviceables::Escrow do
  context 'factory' do
    before do
      @escrow = ChineseFactory::Serviceables::Escrow.mock
    end
    it 'should be valid' do
      @escrow.should be_a Spree::Serviceables::Escrow
    end
  end
end