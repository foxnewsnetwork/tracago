require 'spec_helper'

describe Spree::Serviceables::Truck do
  context 'factory' do
    before do
      @truck = ChineseFactory::Serviceables::Truck.mock
    end
    it 'should be a proper truck' do
      @truck.should be_a Spree::Serviceables::Truck
    end
  end
end